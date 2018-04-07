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

  # A Person represents a person in a CITATION.cff file. A Person might have a
  # number of roles, such as author, contact, editor, etc.
  class Person < ModelPart

    ALLOWED_FIELDS = [
      'address', 'affiliation', 'city', 'country', 'email', 'family-names',
      'fax', 'given-names', 'name-particle', 'name-suffix', 'orcid',
      'post-code', 'region', 'tel', 'website'
    ].freeze # :nodoc:

    # :call-seq:
    #   new(given_name, family_name) -> Person
    #
    # Create a new Person with the supplied given and family names.
    def initialize(param, *more)
      if param.is_a?(Hash)
        @fields = param
      else
        @fields = Hash.new('')
        @fields['family-names'] = more[0]
        @fields['given-names'] = param
      end
    end
  end
end
