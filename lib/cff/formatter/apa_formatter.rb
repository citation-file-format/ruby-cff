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
  # Generates an APALIKE citation string
  class ApaFormatter < Formatter # :nodoc:

    def self.format(model:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      output = +''
      output << combine_authors(model.authors.map { |author| format_author(author) }) if model.authors.length.positive?
      output << '. ' if model.authors&.length&.positive?
      if present?(model.date_released) && !try_get_year(model.date_released).nil?
        output << "(#{try_get_year(model.date_released)}). "
      end
      output << model.title.to_s if present?(model.title)
      output << " (version #{model.version})." if present?(model.version)
      output << " DOI: https://doi.org/#{model.doi}" if present?(model.doi)
      output << " URL: #{model.repository_code}" if present?(model.repository_code)
      output
    rescue StandardError
      nil
    end

    def self.combine_authors(authors)
      authors.join('., ')
    end

    def self.format_author(author) # rubocop:disable Metrics/AbcSize
      if author.is_a?(Person)
        output = +''
        output << "#{author.name_particle} " if present?(author.name_particle)
        output << author.family_names if present?(author.family_names)
        output << " #{author.name_suffix}" if present?(author.name_suffix)
        output << " #{initials(author.given_names)}" if present?(author.given_names)
        return output
      end

      return author.name if author.is_a?(Entity)
    end
  end
end
