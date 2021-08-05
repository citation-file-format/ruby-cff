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

    def self.required_fields?(model)
      !(model.authors.empty? || model.title.empty? || model.version.to_s.empty?)
    end

    def self.present?(attribute)
      return attribute && !attribute.empty? if defined?(attribute) && defined?(attribute.empty?)

      attribute
    end

    def self.initials(name)
      name.split.map { |part| part[0].capitalize }.join('.')
    end

    def self.combine_authors(authors)
      raise NotImplementedError
    end

    # Prefer `repository_code` over `url`
    def self.url(model)
      model.repository_code.empty? ? model.url : model.repository_code
    end

    def self.month_and_year_from_date(value)
      if value.is_a?(Date)
        [value.month, value.year]
      else
        begin
          date = Date.parse(value.to_s)
          [date.month, date.year]
        rescue ArgumentError
          ['', '']
        end
      end
    end

    def self.try_get_month(value)
      if value.instance_of? Date
        value.month
      else
        begin
          date = Date.parse(value.to_s)
          date.month.to_s
        rescue ArgumentError
          nil
        end
      end
    end

    def self.try_get_year(value)
      if value.instance_of? Date
        value.year
      else
        begin
          date = Date.parse(value.to_s)
          date.year.to_s
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
