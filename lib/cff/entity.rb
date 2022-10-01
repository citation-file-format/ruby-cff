# frozen_string_literal: true

# Copyright (c) 2018-2022 The Ruby Citation File Format Developers.
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
  # An Entity can represent different types of entities, e.g., a publishing
  # company, or conference. Like a Person, an Entity might have a number of
  # roles, such as author, contact, editor, etc.
  #
  # Entity implements all of the fields listed in the
  # [CFF standard](https://citation-file-format.github.io/). All fields
  # are simple strings and can be set as such. A field which has not been set
  # will return the empty string. The simple fields are (with defaults in
  # parentheses):
  #
  # * `address`
  # * `alias`
  # * `city`
  # * `country`
  # * `date_end` - *Note:* returns a `Date` object
  # * `date_start` - *Note:* returns a `Date` object
  # * `email`
  # * `fax`
  # * `location`
  # * `name`
  # * `orcid`
  # * `post_code`
  # * `region`
  # * `tel`
  # * `website`
  class Entity < ModelPart
    # :nodoc:
    ALLOWED_FIELDS = SCHEMA_FILE['definitions']['entity']['properties'].keys.freeze

    # :call-seq:
    #   new(name) -> Entity
    #   new(name) { |entity| block } -> Entity
    #
    # Create a new Entity with the supplied name.
    def initialize(param)
      super()

      if param.is_a?(Hash)
        @fields = param
      else
        @fields = {}
        @fields['name'] = param
      end

      yield self if block_given?
    end

    # :call-seq:
    #   date_end = date
    #
    # Set the `date-end` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_end=(date)
      date = Date.parse(date) unless date.is_a?(Date)

      @fields['date-end'] = date
    end

    # :call-seq:
    #   date_start = date
    #
    # Set the `date-start` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_start=(date)
      date = Date.parse(date) unless date.is_a?(Date)

      @fields['date-start'] = date
    end
  end
end
