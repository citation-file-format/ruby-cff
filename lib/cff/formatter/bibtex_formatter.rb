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

    def self.format(model:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      values = {}
      if model.authors.length.positive?
        values['author'] = combine_authors(model.authors.map { |author| format_author(author) })
      end
      values['title'] = "{#{model.title}}" if present?(model.title)
      values['doi'] = model.doi if present?(model.doi)

      if present?(model.date_released) && !try_get_month(model.date_released).nil?
        values['month'] =
          try_get_month(model.date_released)
      end
      if present?(model.date_released) && !try_get_year(model.date_released).nil?
        values['year'] =
          try_get_year(model.date_released)
      end

      # prefer repository_code over url
      if present?(model.repository_code)
        values['url'] = model.repository_code
      elsif present?(model.url)
        values['url'] = model.url
      end

      sorted_values = values.sort.map { |key, value| pair(key: key, value: value) }
      sorted_values.insert(0, "@misc{#{generate_reference(values)}")

      output = sorted_values.join(",\n")
      output << "\n}"

      output
    rescue StandardError
      nil
    end

    def self.pair(key:, value:)
      "#{key} = {#{value}}" if present?(value)
    end

    def self.format_author(author)
      if author.is_a?(Person)
        particle =
          present?(author.name_particle) ? "#{author.name_particle} " : ''

        output = []
        output << "#{particle}#{author.family_names}" if present?(author.family_names)
        output << author.name_suffix if present?(author.name_suffix)
        output << author.given_names if present?(author.given_names)
        return output.join(', ')
      end

      return "{#{author.name}}" if author.is_a?(Entity)
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
