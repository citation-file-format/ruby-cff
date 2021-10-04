# frozen_string_literal: true

# Copyright (c) 2018-2021 The Ruby Citation File Format Developers.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##
module CFF
  # Generates an BibTex citation string
  class BibtexFormatter < Formatter # :nodoc:

    # Fields without `!` have a simple one-to-one mapping between CFF and
    # BibTeX. Those with `!` call out to a more complex getter.
    ENTRY_TYPE_MAP = {
      'article' => %w[doi journal number! pages! volume],
      'book' => %w[address! doi isbn number! pages! publisher! volume],
      'inproceedings' => %w[address! booktitle! doi pages! publisher! series!],
      'manual' => %w[address! doi],
      'misc' => %w[doi pages!],
      'proceedings' => %w[address! booktitle! doi pages! publisher! series!],
      'software' => %w[doi license version]
    }.freeze

    def self.format(model:, preferred_citation: true) # rubocop:disable Metrics/AbcSize
      model = select_and_check_model(model, preferred_citation)
      return if model.nil?

      values = {}
      values['author'] = combine_authors(
        model.authors.map { |author| format_author(author) }
      )
      values['title'] = "{#{model.title}}"

      publication_type = bibtex_type(model)
      publication_data_from_model(model, publication_type, values)

      month, year = month_and_year_from_model(model)
      values['month'] = month
      values['year'] = year

      values['url'] = url(model)

      values.reject! { |_, v| v.empty? }
      sorted_values = values.sort.map do |key, value|
        "#{key} = {#{value}}"
      end
      sorted_values.insert(0, generate_reference(values))

      "@#{publication_type}{#{sorted_values.join(",\n")}\n}"
    end

    # Get various bits of information about the reference publication.
    # Reference: https://www.bibtex.com/format/
    def self.publication_data_from_model(model, type, fields)
      ENTRY_TYPE_MAP[type].each do |field|
        if model.respond_to?(field)
          fields[field] = model.send(field).to_s
        else
          field = field.chomp('!')
          fields[field] = send("#{field}_from_model", model)
        end
      end
    end

    # BibTeX 'number' is CFF 'issue'.
    def self.number_from_model(model)
      model.issue.to_s
    end

    # BibTeX 'address' is taken from the publisher (book, others) or the
    # conference (inproceedings).
    def self.address_from_model(model)
      entity = if model.type == 'conference-paper'
                 model.conference
               else
                 model.publisher
               end
      return '' if entity == ''

      [entity.city, entity.region, entity.country].reject(&:empty?).join(', ')
    end

    # BibTeX 'booktitle' is CFF 'collection-title'.
    def self.booktitle_from_model(model)
      model.collection_title
    end

    def self.publisher_from_model(model)
      model.publisher == '' ? '' : model.publisher.name
    end

    def self.series_from_model(model)
      model.conference == '' ? '' : model.conference.name
    end

    # Do what we can to map between CFF reference types and bibtex types.
    # References:
    #  * https://www.bibtex.com/e/entry-types/
    #  * https://ctan.gutenberg.eu.org/macros/latex/contrib/biblatex-contrib/biblatex-software/software-biblatex.pdf
    def self.bibtex_type(model)
      return 'software' if model.type.empty? || model.type.include?('software')

      case model.type
      when 'article', 'book', 'manual', 'unpublished'
        model.type
      when 'conference', 'proceedings'
        'proceedings'
      when 'conference-paper'
        'inproceedings'
      when 'magazine-article', 'newspaper-article'
        'article'
      when 'pamphlet'
        'booklet'
      else
        'misc'
      end
    end

    def self.format_author(author)
      return "{#{author.name}}" if author.is_a?(Entity)

      particle =
        author.name_particle.empty? ? '' : "#{author.name_particle} "

      [
        "#{particle}#{author.family_names}",
        author.name_suffix,
        author.given_names
      ].reject(&:empty?).join(', ')
    end

    def self.combine_authors(authors)
      authors.join(' and ')
    end

    def self.generate_reference(fields)
      [
        fields['author'].split(',', 2)[0].tr(' -', '_'),
        fields['title'].split[0..2],
        fields['year']
      ].compact.join('_').tr('-$£%&(){}+!?/\\:;\'"~#', '')
    end
  end
end
