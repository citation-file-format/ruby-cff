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

    # These fields have a one-to-one mapping between CFF and BibTeX.
    ENTRY_TYPE_MAP = {
      'article' => %w[doi journal volume],
      'book' => %w[doi isbn volume],
      'misc' => %w[doi]
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
        fields[field] = model.send(field).to_s
      end

      # BibTeX 'number' is CFF 'issue'.
      fields['number'] = model.issue.to_s if model.respond_to?(:issue)

      fields['pages'] = pages_from_model(model)
    end

    # CFF 'pages' is the number of pages, which has no equivalent in BibTeX.
    # Reference: https://www.bibtex.com/f/pages-field/
    def self.pages_from_model(model)
      return '' if !model.respond_to?(:start) || model.start.to_s.empty?

      start = model.start.to_s
      finish = model.end.to_s
      if finish.empty?
        start
      else
        start == finish ? start : "#{start}--#{finish}"
      end
    end

    # Do what we can to map between CFF reference types and bibtex types.
    # Reference: https://www.bibtex.com/e/entry-types/
    def self.bibtex_type(model)
      return 'misc' unless model.is_a?(Reference)

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
