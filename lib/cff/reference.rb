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
      'copyright',
      'data-type',
      'database',
      'department',
      'doi',
      'edition',
      'entry',
      'filename',
      'isbn',
      'issn',
      'issue-title',
      'journal',
      'license',
      'license-url',
      'medium',
      'nihmsid',
      'notes',
      'number',
      'pmcid',
      'repository',
      'repository-code',
      'repository-artifact',
      'scope',
      'section',
      'status',
      'thesis-type',
      'title',
      'type',
      'url',
      'version',
      'volume-title'
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

    # :call-seq:
    #   new(title, type) -> Reference
    #
    # Create a new Reference with the supplied title and type. If type is not one of the [defined set of reference types](https://citation-file-format.github.io/1.0.3/specifications/#/reference-types), 'generic' will be used by default.
    def initialize(param, *more)
      @authors = []

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
    #   type = type
    #
    # Sets the type of this reference. The type is restricted to a
    # [defined set of reference types](https://citation-file-format.github.io/1.0.3/specifications/#/reference-types).
    def type=(type)
      @fields['type'] = type if REFERENCE_TYPES.include?(type)
    end

    # Override superclass fields as references contain model parts too.
    def fields # :nodoc:
      ref = @fields.dup
      ref['authors'] = array_to_fields(@authors) unless @authors.empty?

      ref
    end

    private

    def build_model(fields)
      build_actor_collection(@authors, fields['authors'])

      @fields = delete_from_hash(fields, 'authors')
    end

  end
end
