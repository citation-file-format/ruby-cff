module CFF
  class ApaFormatter < Formatter

    def self.format(model:)
      output = ""
      output << combine_authors(model.authors.map { |author| format_author(author) })
      output << ". " if model.authors&.length > 0
      output << "(#{model.date_released.strftime("%Y")}). " if present?(model.date_released)
      output << "#{model.title}"
      output << " (version #{model.version})." if present?(model.version)
      output << " DOI: http://doi.org/#{model.doi} " if present?(model.doi)
      output << "URL: #{model.repository_code}" if present?(model.repository_code)
      return output
    end


  end
end