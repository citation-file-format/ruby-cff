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

    def self.format(model:, preferred_citation: true) # rubocop:disable Metrics/AbcSize
      model = select_and_check_model(model, preferred_citation)
      return if model.nil?

      values = {}
      if model.authors.length.positive?
        values['author'] = combine_authors(
          model.authors.map { |author| format_author(author) }
        )
      end
      values['title'] = "{#{model.title}}"
      values['doi'] = model.doi

      month, year = month_and_year_from_date(model.date_released)
      values['month'] = month.to_s
      values['year'] = year.to_s

      values['url'] = url(model)

      values.reject! { |_, v| v.empty? }
      sorted_values = values.sort.map do |key, value|
        "#{key} = {#{value}}"
      end
      sorted_values.insert(0, generate_reference(values))

      "@#{bibtex_type(model)}{#{sorted_values.join(",\n")}\n}"
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
