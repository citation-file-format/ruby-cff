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

  # ModelPart is the superclass of anything that makes up part of the CFF Index.
  # This includes Index, Person, Entity and Reference.
  #
  # ModelPart provides only one method for the public API: `empty?`.
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
        @fields[n].nil? ? '' : @fields[n]
      end
    end

    def respond_to_missing?(name, *)
      n = method_to_field(name.id2name)
      self.class::ALLOWED_FIELDS.include?(n.chomp('=')) || super
    end
    # :startdoc:

    # :call-seq:
    #   empty? -> false
    #
    # Define `empty?` for CFF classes so that they can be tested in the
    # same way as strings and arrays.
    #
    # This always returns `false` because CFF classes always return something
    # from all of their methods.
    def empty?
      false
    end
  end
end
