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

  # ModelPart is the superclass of anything that makes up part of the CFF Model.
  # This includes Model, Person, Entity and Reference.
  #
  # ModelPart does not provide any methods or fields for the public API.
  class ModelPart

    # :stopdoc:
    include Util

    attr_reader :fields

    def method_missing(name, *args)
      n = method_to_field(name.id2name)
      super unless self.class::ALLOWED_FIELDS.include?(n.chomp('='))

      if n.end_with?('=')
        @fields[n.chomp('=')] = args[0] || ''
      else
        @fields[n]
      end
    end

    def respond_to_missing?(name, *)
      n = method_to_field(name.id2name)
      self.class::ALLOWED_FIELDS.include?(n.chomp('=')) || super
    end

    # :startdoc:
  end
end
