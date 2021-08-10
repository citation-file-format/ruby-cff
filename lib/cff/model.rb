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

  # Model is the core data structure for a CITATION.cff file. It can be
  # accessed direcly, or via File.
  #
  # Model implements all of the fields listed in the
  # [CFF standard](https://citation-file-format.github.io/). Complex
  # fields - `authors`, `contact`, `identifiers`, `keywords`,
  # `preferred-citation` and `references` - are documented below. All other
  # fields are simple strings and can be set as such. A field which has not
  # been set will return the empty string. The simple fields are (with defaults
  # in parentheses):
  #
  # * `abstract`
  # * `cff_version`
  # * `commit`
  # * `date_released` - *Note:* returns a `Date` object
  # * `doi`
  # * `license`
  # * `license_url`
  # * `message` (If you use this software in your work, please cite it using
  # the following metadata)
  # * `repository`
  # * `repository_artifact`
  # * `repository_code`
  # * `title`
  # * `url`
  # * `version`
  class Model < ModelPart

    include Licensable
    include Validatable

    ALLOWED_FIELDS = [
      'abstract', 'authors', 'cff-version', 'contact', 'commit',
      'date-released', 'doi', 'identifiers', 'keywords', 'license',
      'license-url', 'message', 'preferred-citation', 'references',
      'repository', 'repository-artifact', 'repository-code', 'title',
      'url', 'version'
    ].freeze # :nodoc:

    # The default message to use if none is explicitly set.
    DEFAULT_MESSAGE = 'If you use this software in your work, please cite ' \
                      'it using the following metadata'

    # :call-seq:
    #   new(title) -> Model
    #   new(title) { |model| block } -> Model
    #
    # Initialize a new Model with the supplied title.
    def initialize(param)
      if param.is_a?(Hash)
        @fields = build_model(param)
        @fields.default = ''
      else
        @fields = Hash.new('')
        @fields['cff-version'] = DEFAULT_SPEC_VERSION
        @fields['message'] = DEFAULT_MESSAGE
        @fields['title'] = param
      end

      %w[authors contact identifiers keywords references].each do |field|
        @fields[field] = [] if @fields[field].empty?
      end

      yield self if block_given?
    end

    # :call-seq:
    #   read(String) -> Model
    #
    # Read a CFF Model from a String and parse it for subsequent manipulation.
    def self.read(model)
      new(YAML.safe_load(model, permitted_classes: [Date, Time]))
    end

    # :call-seq:
    #   date_released = date
    #
    # Set the `date-released` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_released=(date)
      date = Date.parse(date) unless date.is_a?(Date)

      @fields['date-released'] = date
    end

    def to_yaml # :nodoc:
      YAML.dump fields, line_width: -1, indentation: 2
    end

    # :call-seq:
    #   to_apalike(preferred_citation: true) -> String
    #
    # Output this Model in an APA-like format. Setting
    # `preferred_citation: true` will honour the `preferred_citation` field in
    # the model if one is present (default).
    #
    # *Note:* This method assumes that this Model is valid when called.
    def to_apalike(preferred_citation: true)
      CFF::ApaFormatter.format(
        model: self, preferred_citation: preferred_citation
      )
    end

    # :call-seq:
    #   to_bibtex(preferred_citation: true) -> String
    #
    # Output this Model in BibTeX format. Setting
    # `preferred_citation: true` will honour the `preferred_citation` field in
    # the model if one is present (default).
    #
    # *Note:* This method assumes that this Model is valid when called.
    def to_bibtex(preferred_citation: true)
      CFF::BibtexFormatter.format(
        model: self, preferred_citation: preferred_citation
      )
    end

    private

    def fields
      %w[authors contact identifiers references].each do |field|
        normalize_modelpart_array!(@fields[field])
      end

      fields_to_hash(@fields)
    end

    def build_model(fields) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
      build_actor_collection!(fields['authors'] || [])
      build_actor_collection!(fields['contact'] || [])
      (fields['identifiers'] || []).map! do |i|
        Identifier.new(i)
      end
      (fields['references'] || []).map! do |r|
        Reference.new(r)
      end
      fields['preferred-citation'] &&=
        Reference.new(fields['preferred-citation'])

      # Only attempt an update of the `cff-version` field if it is present.
      fields['cff-version'] &&= update_cff_version(fields['cff-version'])

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
    # :method: identifiers
    # :call-seq:
    #   identifiers -> Array
    #
    # Return the list of identifiers for this citation. To add a identifier to
    # the list, use:
    #
    # ```
    # model.identifiers << identifier
    # ```

    ##
    # :method: identifiers=
    # :call-seq:
    #   identifiers = array_of_identifiers -> Array
    #
    # Replace the list of identifiers for this citation.

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
    # :method: preferred_citation
    # :call-seq:
    #   preferred_citation -> Reference
    #
    # Return the preferred citation for this citation.

    ##
    # :method: preferred_citation=
    # :call-seq:
    #   preferred_citation = Reference
    #
    # Replace the preferred citation for this citation.

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
