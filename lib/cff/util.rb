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

#
module CFF

  # :stopdoc:
  # Utility methods useful throughout the rest of the CFF library.
  # This module is not in the public API.
  module Util

    def delete_from_hash(hash, *keys)
      h = hash.dup
      keys.each { |key| h.delete(key) }
      h
    end

    def method_to_field(name)
      name.gsub('_', '-')
    end

    def build_actor_collection(field, source)
      source.each do |s|
        field << (s.has_key?('given-names') ? Person.new(s) : Entity.new(s))
      end
    end

    def expand_field(field)
      field.fields if field.respond_to?(:fields)
    end

    def expand_array_field(field)
      field.reject do |f|
        !f.respond_to?(:fields)
      end.map { |f| f.fields }
    end

  end
  # :startdoc:
end
