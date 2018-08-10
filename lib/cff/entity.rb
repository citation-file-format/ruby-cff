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

  # An Entity can represent different types of entities, e.g., a publishing
  # company, or conference. Like a Person, an Entity might have a number of
  # roles, such as author, contact, editor, etc.
  #
  # Entity implements all of the fields listed in the CFF standard. All fields
  # are simple strings and can be set as such. A field which has not been set
  # will return the empty string. The simple fields are (with defaults in
  # parentheses):
  #
  # * `address`
  # * `city`
  # * `country`
  # * `email`
  # * `date_end` - *Note:* returns a `Date` object
  # * `date_start` - *Note:* returns a `Date` object
  # * `fax`
  # * `location`
  # * `name`
  # * `orcid`
  # * `post_code`
  # * `region`
  # * `tel`
  # * `website`
  class Entity < ModelPart

    ALLOWED_FIELDS = [
      'address', 'city', 'country', 'email', 'date-end', 'date-start', 'fax',
      'location', 'name', 'orcid', 'post-code', 'region', 'tel', 'website'
    ].freeze # :nodoc:

    # :call-seq:
    #   new(name) -> Entity
    #
    # Create a new Entity with the supplied name.
    def initialize(param)
      if param.is_a?(Hash)
        @fields = param
      else
        @fields = Hash.new('')
        @fields['name'] = param
      end
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
