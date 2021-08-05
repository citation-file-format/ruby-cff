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
  # initial set of preferred citation styles, based on the list used by
  # Crossref and DataCite Search:

  # apa
  # chicago-fullnote-bibliography
  # harvard-cite-them-right
  # ieee
  # university-of-york-mla
  # vancouver

  # Generates a formatted citation using citation style language (CSL)
  # and the Ruby Citeproc processor
  class CslFormatter < Formatter # :nodoc:

    def self.format(model:, style: 'apa', locale: 'en-US') # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      return nil unless required_fields?(model)

      CSL::Style.root = ::File.expand_path('../../../lib/styles', __dir__)
      CSL::Locale.root = ::File.expand_path('../../../lib/locales', __dir__)

      id = present?(model.doi) ? "https://doi.org/#{model.doi}" : nil

      # citeproc_hsh is input format for citeproc-ruby
      citeproc_hsh = {
        # using type book is workaround for software for current CSL version
        'type' => 'book',
        'id' => present?(model.doi) ? "https://doi.org/#{model.doi}" : nil,
        'categories' => Array.wrap(model.keywords),
        'language' => 'eng', # Array.wrap(model.languages).first,
        'author' => to_citeproc(model.authors),
        'issued' => get_date_parts(model.date_released.to_s),
        'abstract' => model.abstract,
        #   'container-title' => container_title,
        'DOI' => model.doi,
        #   'publisher' => publisher,
        'title' => model.title,
        'URL' => present?(model.repository_code) ? model.repository_code : model.url,
        # 'copyright' => model.copyright,
        'version' => model.version
      }.compact.symbolize_keys

      cp = CiteProc::Processor.new style: style, locale: locale, format: 'html'
      cp.import Array.wrap(citeproc_hsh)
      bibliography = cp.render :bibliography, id: id
      bibliography.first
    end

    # change authors into a format citeproc understands
    def self.to_citeproc(element)
      Array.wrap(element).map do |a|
        {
          'given' => a.fields['given-names'],
          'non-dropping-particle' => a.fields['name-particle'],
          'family' => a.fields['family-names'],
          'suffix' => a.fields['name-suffix'],
          'literal' => a.fields['name']
        }.compact
      end
    end

    # citeproc uses dates formatted as date parts
    def self.get_date_parts(iso8601_time)
      return { 'date-parts' => [[]] } unless present?(iso8601_time)

      year = iso8601_time[0..3].to_i
      month = iso8601_time[5..6].to_i
      day = iso8601_time[8..9].to_i
      { 'date-parts' => [[year, month, day].reject(&:zero?)] }
    rescue TypeError
      nil
    end
  end
end
