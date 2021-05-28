# frozen_string_literal: true

module CFF

  # Generates an APALIKE citation string
  class ApaFormatter < Formatter

    def self.format(model:) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return nil unless required_fields?(model)

      output = +''
      output << combine_authors(model.authors.map { |author| format_author(author) })
      output << '. ' if model.authors&.length&.positive?
      output << "(#{model.date_released.strftime('%Y')}). " if present?(model.date_released)
      output << model.title.to_s if present?(model.title)
      output << " (version #{model.version})." if present?(model.version)
      output << " DOI: http://doi.org/#{model.doi}" if present?(model.doi)
      output << " URL: #{model.repository_code}" if present?(model.repository_code)
      output
    rescue StandardError
      nil
    end
  end
end
