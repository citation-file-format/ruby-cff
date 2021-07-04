# frozen_string_literal: true

module CFF
  # Generates an BibTex citation string
  class BibtexFormatter < Formatter

    def self.format(model:) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      values = {}
      if model.authors.length.positive?
        values['author'] = combine_authors(model.authors.map { |author| format_author(author) })
      end
      values['title'] = model.title if present?(model.title)
      values['doi'] = model.doi if present?(model.doi)

      if present?(model.date_released) && !try_get_month(model.date_released).nil?
        values['month'] =
          try_get_month(model.date_released)
      end
      if present?(model.date_released) && !try_get_year(model.date_released).nil?
        values['year'] =
          try_get_year(model.date_released)
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

    def self.format_author(author)
      if author.is_a?(Person)
        output = []
        output << author.family_names if present?(author.family_names)
        output << author.given_names if present?(author.given_names)
        return output.join(', ')
      end

      return author.name if author.is_a?(Entity)
    end

    def self.combine_authors(authors)
      authors.join(' and ')
    end
  end
end
