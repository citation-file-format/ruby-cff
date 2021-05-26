module CFF
  class BibtexFormatter < Formatter
    def self.format(model:)
      return nil unless self.has_required_fields?(model)

      values = {}
      values["author"] = combine_authors(model.authors.map { |author| format_author(author) })
      values["title"] = model.title if present?(model.title)
      values["doi"] = model.doi if present?(model.doi)

      values["month"] = model.date_released.month.to_s if present?(model.date_released) && present?(model.date_released.month)
      values["year"] = model.date_released.year.to_s if present?(model.date_released) && present?(model.date_released.year)

      # prefer repository_code over url
      if present?(model.repository_code)
        values["url"] = model.repository_code
      else
        values["url"] = model.url if present?(model.url)
      end

      sorted_values = values.sort.map { |key, value| pair(key: key, value: value) }
      sorted_values.insert(0, "@misc{YourReferenceHere")

      output = sorted_values.join(",\n")
      output << "\n}"

      return output

    rescue
      return nil
    end

    private

    def self.pair(key:, value:)
      "#{key} = {#{value}}" if present?(value)
    end
  end
end
