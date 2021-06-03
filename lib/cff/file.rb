# frozen_string_literal: true

# Copyright (c) 2018-2021 The Ruby Citation File Format Developers.
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

  # File provides direct access to a CFF Model, with the addition of some
  # filesystem utilities.
  class File

    # A comment to be inserted at the top of the resultant CFF file.
    attr_reader :comment

    # The filename of this CFF file.
    attr_reader :filename

    YAML_HEADER = "---\n" # :nodoc:
    CFF_COMMENT = [
      "This CITATION.cff file was created by ruby-cff (v #{CFF::VERSION}).",
      'Gem: https://rubygems.org/gems/cff',
      'CFF: https://citation-file-format.github.io/'
    ].freeze # :nodoc:

    # :call-seq:
    #   new(filename, title) -> File
    #   new(filename, model) -> File
    #
    # Create a new File. Either a pre-existing Model can be passed in or, as
    # with Model itself, a title can be supplied to initalize a new File.
    #
    # All methods provided by Model are also available directly on File
    # objects.
    def initialize(filename, param, comment = CFF_COMMENT, create: false)
      param = Model.new(param) unless param.is_a?(Model)

      @filename = filename
      @model = param
      @comment = comment
      @dirty = create
    end

    # :call-seq:
    #   read(file) -> File
    #
    # Read a file and parse it for subsequent manipulation.
    def self.read(file)
      content = ::File.read(file)
      comment = File.parse_comment(content)

      new(
        file, YAML.safe_load(content, permitted_classes: [Date, Time]), comment
      )
    end

    def self.open(file)
      if ::File.exist?(file)
        content = ::File.read(file)
        comment = File.parse_comment(content)
        yaml = YAML.safe_load(content, permitted_classes: [Date, Time])
      else
        comment = CFF_COMMENT
        yaml = ''
      end

      cff = new(file, yaml, comment, create: (yaml == ''))
      return cff unless block_given?

      begin
        yield cff
      ensure
        cff.write
      end
    end

    # :call-seq:
    #   write(file, model)
    #   write(file, yaml)
    #
    # Write the supplied model or yaml string to `file`.
    def self.write(file, cff, comment = '')
      cff = cff.to_yaml unless cff.is_a?(String)
      content = File.format_comment(comment) + cff[YAML_HEADER.length...-1]

      ::File.write(file, content)
    end

    # :call-seq:
    #   write(file)
    #
    # Write this CFF File to `file`.
    def write
      File.write(@filename, @model, @comment) if @dirty
      @dirty = false
    end

    # :call-seq:
    #   comment = string or array
    #
    # A comment to be inserted at the top of the resultant CFF file. This can
    # be supplied as a simple string or an array of strings. When the file is
    # saved this comment is formatted as follows:
    #
    # * a simple string is split into 75 character lines and `'# '` is prepended
    # to each line;
    # * an array of strings is joined into a single string with `'\n'` and
    # `'# '` is prepended to each line;
    #
    # If you care about formatting, use an array of strings for your comment,
    # if not, use a single string.
    def comment=(comment)
      @dirty = true
      @comment = comment
    end

    def method_missing(name, *args) # :nodoc:
      if @model.respond_to?(name)
        @dirty = true if name.to_s.end_with?('=') # Remove to_s when Ruby >2.6.
        @model.send(name, *args)
      else
        super
      end
    end

    def respond_to_missing?(name, *all) # :nodoc:
      @model.respond_to?(name, *all)
    end

    def self.format_comment(comment) # :nodoc:
      return '' if comment.empty?

      comment = comment.scan(/.{1,75}/) if comment.is_a?(String)
      c = comment.map do |l|
        l.empty? ? '#' : "# #{l}"
      end.join("\n")

      "#{c}\n\n"
    end

    def self.parse_comment(content) # :nodoc:
      content = content.split("\n")

      content.reduce([]) do |acc, line|
        break acc unless line.start_with?('#')

        acc << line.sub(/^#+/, '').strip
      end
    end
  end
end
