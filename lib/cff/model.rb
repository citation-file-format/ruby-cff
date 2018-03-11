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

  # Model is the core data structure for a CITATION.cff file. It can be
  # accessed direcly, or via File.
  class Model

    include Util

    ALLOWED_FIELDS = [
      'abstract',
      'cff-version',
      'commit',
      'date-released',
      'doi',
      'keywords',
      'license',
      'license-url',
      'message',
      'repository',
      'repository-artifact',
      'repository-code',
      'title',
      'url',
      'version'
  ].freeze # :nodoc:

    # The default message to use if none is explicitly set.
    DEFAULT_MESSAGE = "If you use this software in your work, please cite it using the following metadata"

    # :call-seq:
    #   new(title) -> Model
    #
    # Initialize a new Model with the supplied title.
    def initialize(param)
      @authors = []
      @contact = []
      @references = []

      if Hash === param
        build_model(param)
      else
        @fields = Hash.new('')
        @fields['cff-version'] = DEFAULT_SPEC_VERSION
        @fields['message'] = DEFAULT_MESSAGE
        @fields['title'] = param
      end

      [
        'keywords'
      ].each { |field| @fields[field] = [] if @fields[field].empty? }
    end

    # :call-seq:
    #   authors -> Array
    #
    # Return the list of authors for this citation. To add an author to the
    # list, use:
    #
    # ```
    # model.authors << author
    # ```
    #
    # Authors can be a Person or Entity.
    def authors
      @authors
    end

    # :call-seq:
    #   contact -> Array
    #
    # Return the list of contacts for this citation. To add a contact to the
    # list, use:
    #
    # ```
    # model.contact << contact
    # ```
    #
    # Contacts can be a Person or Entity.
    def contact
      @contact
    end

    # :call-seq:
    #   date_released = date
    #
    # Set the `date-released` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_released=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-released'] = date
    end

    # :call-seq:
    #   references -> Array
    #
    # Return the list of references for this citation. To add a reference to the
    # list, use:
    #
    # ```
    # model.references << reference
    # ```
    def references
      @references
    end

    # :call-seq:
    #   version = version
    #
    # Set the `version` field.
    def version=(version)
      @fields['version'] = version.to_s
    end

    def to_yaml # :nodoc:
      YAML.dump fields, :line_width => -1, :indentation => 2
    end

    def method_missing(name, *args) # :nodoc:
      n = method_to_field(name.id2name)
      super unless ALLOWED_FIELDS.include?(n.chomp('='))

      if n.end_with?('=')
        @fields[n.chomp('=')] = args[0] || ''
      else
        @fields[n]
      end
    end

    private

    def fields
      model = {}

      @fields.each do |field, value|
        if value.respond_to?(:map)
          model[field] = value.map { |v| v.to_s } unless value.empty?
        else
          model[field] = value.respond_to?(:fields) ? value.fields : value
        end
      end

      [
        ['authors', @authors],
        ['contact', @contact],
        ['references', @references]
      ].each do |field, var|
        model[field] = expand_array_field(var) unless var.empty?
      end

      model
    end

    def build_model(fields)
      build_actor_collection(@authors, fields['authors'])
      build_actor_collection(@contact, fields['contact'])
      fields['references'].each do |r|
        @references << Reference.new(r)
      end

      @fields = delete_from_hash(fields, 'authors', 'contact', 'references')
    end

    public

    # Some documentation of "hidden" methods is provided here, out of the
    # way of the main class code.

    ##
    # :method: keywords
    # :call-seq:
    #   keywords -> Array
    #
    # Return the list of keywords for this reference. To add a keyword to the
    # list, use:
    #
    # ```
    # model.keywords << keyword
    # ```
    #
    # Keywords will be converted to Strings on output.

    ##
    # :method: keywords=
    # :call-seq:
    #   keywords = array_of_keywords -> Array
    #
    # Replace the list of keywords for this reference.
    #
    # Keywords will be converted to Strings on output.

  end
end
