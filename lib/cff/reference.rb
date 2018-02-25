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

  # Reference provides a reference pertaining to the software version or the
  # software itself, e.g., a software paper describing the abstract concepts of
  # the software, a paper describing an algorithm that has been implemented in
  # the software version, etc.
  class Reference < ModelPart

    ALLOWED_FIELDS = [
      'title',
      'type'
    ].freeze # :nodoc:

    # :call-seq:
    #   new(title, type) -> Reference
    #
    # Create a new Reference with the supplied title and type.
    def initialize(param, *more)
      if Hash === param
        super(param)
      else
        @fields = Hash.new('')
        @fields['type'] = more[0]
        @fields['title'] = param
      end
    end

  end
end
