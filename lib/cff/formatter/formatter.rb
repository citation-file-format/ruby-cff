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
  # Formatter base class
  class Formatter # :nodoc:

    def self.select_and_check_model(model, preferred_citation)
      if preferred_citation && model.preferred_citation.is_a?(Reference)
        model = model.preferred_citation
      end

      # Safe to assume valid `Model`s and `Reference`s will have these fields.
      model.authors.empty? || model.title.empty? ? nil : model
    end

    def self.initials(name)
      name.split.map { |part| part[0].capitalize }.join('. ')
    end

    # Prefer `repository_code` over `url`
    def self.url(model)
      model.repository_code.empty? ? model.url : model.repository_code
    end

    def self.month_and_year_from_model(model)
      if model.respond_to?(:year) && !model.year.to_s.empty?
        return [model.month, model.year].map(&:to_s)
      end

      month_and_year_from_date(model.date_released)
    end

    def self.month_and_year_from_date(value)
      if value.is_a?(Date)
        [value.month, value.year].map(&:to_s)
      else
        begin
          date = Date.parse(value.to_s)
          [date.month, date.year].map(&:to_s)
        rescue ArgumentError
          ['', '']
        end
      end
    end

    # CFF 'pages' is the number of pages, which has no equivalent in BibTeX
    # or APA. References: https://www.bibtex.com/f/pages-field/,
    # https://apastyle.apa.org/style-grammar-guidelines/references/examples
    def self.pages_from_model(model, dash: '--')
      return '' if !model.respond_to?(:start) || model.start.to_s.empty?

      start = model.start.to_s
      finish = model.end.to_s
      if finish.empty?
        start
      else
        start == finish ? start : "#{start}#{dash}#{finish}"
      end
    end
  end
end
