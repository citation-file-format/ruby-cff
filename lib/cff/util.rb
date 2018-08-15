# frozen_string_literal: true

# Copyright (c) 2018 Robert Haines.
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

  # Util provides utility methods useful throughout the rest of the CFF library.
  #
  # Util does not provide any methods or fields for the public API.
  module Util
    # :stopdoc:

    def method_to_field(name)
      name.tr('_', '-')
    end

    def build_actor_collection!(source)
      source.map! do |s|
        s.has_key?('given-names') ? Person.new(s) : Entity.new(s)
      end
    end

    def normalize_modelpart_array!(array)
      array.select! { |i| i.respond_to?(:fields) }
    end

    def fields_to_hash(fields)
      hash = {}

      fields.each do |field, value|
        if value.respond_to?(:map)
          unless value.empty?
            hash[field] = value.map do |v|
              v.respond_to?(:fields) ? v.fields : v.to_s
            end
          end
        else
          hash[field] = value.respond_to?(:fields) ? value.fields : value
        end
      end

      hash
    end

    # :startdoc:
  end
end
