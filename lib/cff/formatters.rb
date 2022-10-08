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
  # A registry of output formatters for converting CFF files into citations.
  module Formatters
    @formatters = {}

    # :call-seq:
    #   register_formatter(class)
    #
    # Register a citation formatter. To be registered as a formatter, a
    # class should at least provide:
    #
    # * the constant `CITATION_FORMAT`, which should be a minimal descriptive
    #   name for the format, e.g. `'BibTeX'`; and
    # * the method `format`, which takes the to model to be formatted.
    def self.register_formatter(clazz)
      return unless clazz.singleton_methods.include?(:format)
      return if @formatters.has_value?(clazz)

      @formatters[clazz.label.downcase.to_sym] = clazz
    end

    def self.formatter_for(format) # :nodoc:
      @formatters[format.downcase.to_sym]
    end
  end
end

require_relative 'formatters/all'
