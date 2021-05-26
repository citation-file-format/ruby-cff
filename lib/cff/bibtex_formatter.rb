module CFF
  class BibtexFormatter < Formatter
    def self.format(model:)
      output = ""

      supported_bibtex_props = ['author', 'doi', 'month', 'title', 'url', 'year']

      values = {}
      values["author"] = combine_authors(model.authors.map { |author| format_author(author) })
      values["title"] = model.title if present?(model.title)
      values["doi"] = model.doi if present?(model.doi)

      values["month"] = model.date_released.month.to_s if model.date_released && present?(model.date_released.month)
      values["year"] = model.date_released.year.to_s if model.date_released && present?(model.date_released.year)

      # prefer repository_code over url
      if present?(model.repository_code)
        values["url"] = model.repository_code
      else
        values["url"] = model.url if present?(model.url)
      end


      output = "@misc{YourReferenceHere,\n"
      output << values.sort.map {|key, value| pair(key: key, value: value) }.join(",\n")
      output << "\n}"

      return output

      # output = ""
      # output << "@misc{\n"
      # output << "authors = " + model.authors.map { |m| format_author(m) }.join(", ") + ",\n"
      # output << "title = {" + model.title + "},\n"
      # output << "url = {" + model.url + "},\n" if model.url
      # output << "year = {" + model.date_released.year.to_s + "},\n"
      # output << "month = {" + model.date_released.month.to_s + "},\n"
      # output << "doi = {" + model.doi + "},\n" if doi
      # output << "}"
    end

    private
    def self.pair(key:, value:)
      if present?(value)
        "#{key} = {#{value}}"
      end
    end

  end
end