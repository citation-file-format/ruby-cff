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

  # An Entity can represent different types of entities, e.g., a publishing
  # company, or conference. Like a Person, an Entity might have a number of
  # roles, such as author, contact, editor, etc.
  class Entity

    attr_reader :fields # :nodoc:

    # :call-seq:
    #   new(name) -> Entity
    #
    # Create a new Entity with the supplied name.
    def initialize(name)
      @fields = Hash.new('')
      @fields['name'] = name
    end

  end
end
