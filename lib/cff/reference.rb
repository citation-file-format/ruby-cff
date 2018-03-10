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
      'abbreviation',
      'abstract',
      'collection-doi',
      'collection-title',
      'collection-type',
      'commit',
      'conference',
      'copyright',
      'data-type',
      'database',
      'database-provider',
      'date-accessed',
      'date-downloaded',
      'date-published',
      'date-released',
      'department',
      'doi',
      'edition',
      'end',
      'entry',
      'filename',
      'institution',
      'isbn',
      'issn',
      'issue',
      'issue-title',
      'journal',
      'license',
      'license-url',
      'loc-end',
      'loc-start',
      'location',
      'medium',
      'month',
      'nihmsid',
      'notes',
      'number',
      'number-volumes',
      'pages',
      'pmcid',
      'publisher',
      'repository',
      'repository-code',
      'repository-artifact',
      'scope',
      'section',
      'start',
      'status',
      'thesis-type',
      'title',
      'type',
      'url',
      'version',
      'volume',
      'volume-title',
      'year',
      'year-original'
    ].freeze # :nodoc:

    # The [defined set of reference types](https://citation-file-format.github.io/1.0.3/specifications/#/reference-types).
    REFERENCE_TYPES = [
      'art',
      'article',
      'audiovisual',
      'bill',
      'blog',
      'book',
      'catalogue',
      'conference',
      'conference-paper',
      'data',
      'database',
      'dictionary',
      'edited-work',
      'encyclopedia',
      'film-broadcast',
      'generic',
      'government-document',
      'grant',
      'hearing',
      'historical-work',
      'legal-case',
      'legal-rule',
      'magazine-article',
      'manual',
      'map',
      'multimedia',
      'music',
      'newspaper-article',
      'pamphlet',
      'patent',
      'personal-communication',
      'proceedings',
      'report',
      'serial',
      'slides',
      'software',
      'software-code',
      'software-container',
      'software-executable',
      'software-virtual-machine',
      'sound-recording',
      'standard',
      'statute',
      'thesis',
      'unpublished',
      'video',
      'website'
    ].freeze

    # The [defined set of reference status types](https://citation-file-format.github.io/1.0.3/specifications/#/status-strings).
    REFERENCE_STATUS_TYPES = [
      'abstract',
      'advance-online',
      'in-preparation',
      'in-press',
      'pre-print',
      'submitted'
    ].freeze

    # :call-seq:
    #   new(title, type) -> Reference
    #
    # Create a new Reference with the supplied title and type. If type is not one of the [defined set of reference types](https://citation-file-format.github.io/1.0.3/specifications/#/reference-types), 'generic' will be used by default.
    def initialize(param, *more)
      @authors = []
      @contact = []
      @editors = []
      @editors_series = []
      @recipients = []
      @senders = []
      @translators = []

      if Hash === param
        build_model(param)
      else
        @fields = Hash.new('')
        @fields['type'] = REFERENCE_TYPES.include?(more[0]) ? more[0] : 'generic'
        @fields['title'] = param
      end
    end

    # :call-seq:
    #   authors -> Array
    #
    # Return the list of authors for this Reference. To add an author to the
    # list, use:
    #
    # ```
    # reference.authors << author
    # ```
    #
    # Authors can be a Person or Entity.
    def authors
      @authors
    end

    # :call-seq:
    #   contact -> Array
    #
    # Return the list of contacts for this Reference. To add a contact to the
    # list, use:
    #
    # ```
    # reference.contact << contact
    # ```
    #
    # Contacts can be a Person or Entity.
    def contact
      @contact
    end

    # :call-seq:
    #   editors -> Array
    #
    # Return the list of editors for this Reference. To add an editor to the
    # list, use:
    #
    # ```
    # reference.editors << editor
    # ```
    #
    # An editor can be a Person or Entity.
    def editors
      @editors
    end

    # :call-seq:
    #   editors_series -> Array
    #
    # Return the list of series editors for this Reference. To add a series
    # editor to the list, use:
    #
    # ```
    # reference.editors_series << editor
    # ```
    #
    # An editor can be a Person or Entity.
    def editors_series
      @editors_series
    end

    # :call-seq:
    #   recipients -> Array
    #
    # Return the list of recipients for this Reference. To add a recipient
    # to the list, use:
    #
    # ```
    # reference.recipients << recipient
    # ```
    #
    # Recipients can be a Person or Entity.
    def recipients
      @recipients
    end

    # :call-seq:
    #   senders -> Array
    #
    # Return the list of senders for this Reference. To add a sender to the
    # list, use:
    #
    # ```
    # reference.senders << sender
    # ```
    #
    # Senders can be a Person or Entity.
    def senders
      @senders
    end

    # :call-seq:
    #   translators -> Array
    #
    # Return the list of translators for this Reference. To add a translator
    # to the list, use:
    #
    # ```
    # reference.translators << translator
    # ```
    #
    # Translators can be a Person or Entity.
    def translators
      @translators
    end

    # :call-seq:
    #   add_language language
    #
    # Add a language to this Reference. Input is converted to the ISO 639-3
    # three letter language code, so `GER` becomes `deu`, `french` becomes
    # `fra` and `en` becomes `eng`.
    def add_language(lang)
      @fields['languages'] = [] if @fields['languages'].empty?
      lang = LanguageList::LanguageInfo.find(lang)
      return if lang.nil?
      lang = lang.iso_639_3
      @fields['languages'] << lang unless @fields['languages'].include? lang
    end

    # :call-seq:
    #   reset_languages
    #
    # Reset the list of languages for this Reference to be empty.
    def reset_languages
      @fields.delete('languages')
    end

    # :call-seq:
    #   languages -> Array
    #
    # Return the list of languages associated with this Reference.
    def languages
      @fields['languages'].empty? ? [] : @fields['languages'].dup
    end

    # :call-seq:
    #   license = license
    #
    # Set the license of this Reference. Only licenses that conform to the
    # [SPDX License List](https://spdx.org/licenses/) will be accepted. If you
    # need specify a different license you should set `license-url` with a link
    # to the license instead.
    def license=(lic)
      @fields['license'] = lic unless SpdxLicenses.lookup(lic).nil?
    end

    # :call-seq:
    #   date_accessed = date
    #
    # Set the `date-accessed` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_accessed=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-accessed'] = date
    end

    # :call-seq:
    #   date_downloaded = date
    #
    # Set the `date-downloaded` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_downloaded=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-downloaded'] = date
    end

    # :call-seq:
    #   date_published = date
    #
    # Set the `date-published` field. If a non-Date object is passed in it will
    # be parsed into a Date.
    def date_published=(date)
      unless Date === date
        date = Date.parse(date)
      end

      @fields['date-published'] = date
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
    #   format -> String
    #
    # Returns the format of this Reference.
    def format
      @fields['format']
    end

    # :call-seq:
    #   format = format
    #
    # Sets the format of this Reference.
    def format=(fmt)
      @fields['format'] = fmt
    end

    # :call-seq:
    #   status = status
    #
    # Sets the status of this Reference. The status is restricted to a
    # [defined set of status types](https://citation-file-format.github.io/1.0.3/specifications/#/status-strings).
    def status=(status)
      @fields['status'] = status if REFERENCE_STATUS_TYPES.include?(status)
    end

    # :call-seq:
    #   type = type
    #
    # Sets the type of this Reference. The type is restricted to a
    # [defined set of reference types](https://citation-file-format.github.io/1.0.3/specifications/#/reference-types).
    def type=(type)
      @fields['type'] = type if REFERENCE_TYPES.include?(type)
    end

    # Override superclass #fields as References contain model parts too.
    def fields # :nodoc:
      ref = {}

      @fields.each do |field, value|
        ref[field] = value.respond_to?(:fields) ? value.fields : value
      end

      [
        ['authors', @authors],
        ['contact', @contact],
        ['editors', @editors],
        ['editors-series', @editors_series],
        ['recipients', @recipients],
        ['senders', @senders],
        ['translators', @translators]
      ].each do |field, var|
        ref[field] = expand_array_field(var) unless var.empty?
      end

      ref
    end

    private

    def build_model(fields)
      build_actor_collection(@authors, fields['authors'])
      build_actor_collection(@contact, fields['contact'])
      build_actor_collection(@editors, fields['editors'])
      build_actor_collection(@editors_series, fields['editors-series'])
      build_actor_collection(@recipients, fields['recipients'])
      build_actor_collection(@senders, fields['senders'])
      build_actor_collection(@translators, fields['translators'])

      @fields = delete_from_hash(fields, 'authors', 'contact', 'editors', 'editors-series', 'recipients', 'senders', 'translators')
    end

  end
end
