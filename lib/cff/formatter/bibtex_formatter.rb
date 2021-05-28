# frozen_string_literal: true

module CFF

  # Generates an BibTex citation string
  class BibtexFormatter < Formatter

    def self.format(model:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      values = {}
      values['author'] = combine_authors(model.authors.map { |author| format_author(author) })
      values['title'] = model.title if present?(model.title)
      values['doi'] = model.doi if present?(model.doi)

      if present?(model.date_released) && present?(model.date_released.month)
        values['month'] =
          model.date_released.month.to_s
      end
      if present?(model.date_released) && present?(model.date_released.year)
        values['year'] =
          model.date_released.year.to_s
      end

      # prefer repository_code over url
      if present?(model.repository_code)
        values['url'] = model.repository_code
      elsif present?(model.url)
        values['url'] = model.url
      end

      sorted_values = values.sort.map { |key, value| pair(key: key, value: value) }
      sorted_values.insert(0, '@misc{YourReferenceHere')

      output = sorted_values.join(",\n")
      output << "\n}"

      output
    rescue StandardError
      nil
    end

    def self.pair(key:, value:)
      "#{key} = {#{value}}" if present?(value)
    end
  end
end
