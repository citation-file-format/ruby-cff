module CFF
  class ApaFormatter

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

    def self.initials(name)
      name.split(" ").map { |part| part[0].capitalize }.join(".")
    end

    def self.format_author(author)
      if author.kind_of?(Person)
        output = ""
        output << "#{author.name_particle} " if present?(author.name_particle)
        output << author.family_names if present?(author.family_names)
        output << " #{author.name_suffix}" if present?(author.name_suffix)
        output << " #{initials(author.given_names)}" if present?(author.given_names)
        return output
      end

      if author.kind_of?(Entity)
        return author.name
      end
    end

    def self.combine_authors(authors)
      #return authors.first

      if authors.length === 1
        return authors.first
      end

      if authors.length === 2
        return "#{authors.first} & #{authors.last}"
      end

      if authors.length > 2 && authors.length <= 5
        return "#{authors[0..authors.length-1].join(", ")} & #{authors.last}"
      end

    end

    def self.present?(attribute)
      if defined?(attribute.empty?)
        return attribute && !attribute.empty?
      end
      return attribute
    end
  end
end