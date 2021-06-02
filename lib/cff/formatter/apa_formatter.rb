# frozen_string_literal: true

module CFF
  # Generates an APALIKE citation string
  class ApaFormatter < Formatter

    def self.format(model:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      output = +''
      output << self.combine_authors(model.authors.map { |author| format_author(author) })
      output << '. ' if model.authors&.length&.positive?
      output << "(#{self.try_get_year(model.date_released)}). " if present?(model.date_released) && self.try_get_year(model.date_released) != nil
      output << model.title.to_s if present?(model.title)
      output << " (version #{model.version})." if present?(model.version)
      output << " DOI: http://doi.org/#{model.doi}" if present?(model.doi)
      output << " URL: #{model.repository_code}" if present?(model.repository_code)
      output
    rescue StandardError => error
      nil
    end

    def self.combine_authors(authors)
      authors.join('., ')
    end
  end
end
