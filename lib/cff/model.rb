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
  class Model < ModelPart

    ALLOWED_FIELDS = [
      'abstract',
      'authors',
      'cff-version',
      'contact',
      'commit',
      'date-released',
      'doi',
      'keywords',
      'license',
      'license-url',
      'message',
      'references',
      'repository',
      'repository-artifact',
      'repository-code',
      'title',
      'url',
      'version'
    ].freeze # :nodoc:

    # The default message to use if none is explicitly set.
    DEFAULT_MESSAGE = "If you use this software in your work, please cite it using the following metadata".freeze

    # :call-seq:
    #   new(title) -> Model
    #
    # Initialize a new Model with the supplied title.
    def initialize(param)
      if param.is_a?(Hash)
        @fields = build_model(param)
      else
        @fields = Hash.new('')
        @fields['cff-version'] = DEFAULT_SPEC_VERSION
        @fields['message'] = DEFAULT_MESSAGE
        @fields['title'] = param
      end

      [
        'authors',
        'contact',
        'keywords',
        'references'
      ].each { |field| @fields[field] = [] if @fields[field].empty? }
    end

    # :call-seq:
    #   date_released = date
    #
    # Set the `date-released` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_released=(date)
      unless date.is_a?(Date)
        date = Date.parse(date)
      end

      @fields['date-released'] = date
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

    private

    def fields
      ['authors', 'contact', 'references'].each do |field|
        normalize_modelpart_array!(@fields[field])
      end
      model = {}

      @fields.each do |field, value|
        if value.respond_to?(:map)
          unless value.empty?
            model[field] = value.map { |v| v.respond_to?(:fields) ? v.fields : v.to_s }
          end
        else
          model[field] = value.respond_to?(:fields) ? value.fields : value
        end
      end

      model
    end

    def build_model(fields)
      build_actor_collection!(fields['authors'])
      build_actor_collection!(fields['contact'])
      fields['references'].map! do |r|
        Reference.new(r)
      end

      fields
    end

    public

    # Some documentation of "hidden" methods is provided here, out of the
    # way of the main class code.

    ##
    # :method: authors
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

    ##
    # :method: authors=
    # :call-seq:
    #   authors = array_of_authors -> Array
    #
    # Replace the list of authors for this citation.
    #
    # Authors can be a Person or Entity.

    ##
    # :method: contact
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

    ##
    # :method: contact=
    # :call-seq:
    #   contact = array_of_contacts -> Array
    #
    # Replace the list of contacts for this citation.
    #
    # Contacts can be a Person or Entity.

    ##
    # :method: keywords
    # :call-seq:
    #   keywords -> Array
    #
    # Return the list of keywords for this citation. To add a keyword to the
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
    # Replace the list of keywords for this citation.
    #
    # Keywords will be converted to Strings on output.

    ##
    # :method: references
    # :call-seq:
    #   references -> Array
    #
    # Return the list of references for this citation. To add a reference to the
    # list, use:
    #
    # ```
    # model.references << reference
    # ```

    ##
    # :method: references=
    # :call-seq:
    #   references = array_of_references -> Array
    #
    # Replace the list of references for this citation.
  end
end
