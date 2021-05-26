module CFF
  class Formatter
    def self.has_required_fields?(model)
      !(model.authors.empty? || !date_present?(model.date_released) || model.title.empty? || model.version.empty?)
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

      return author.name if author.kind_of?(Entity)
    end

    def self.date_present?(attribute)
      if attribute.kind_of?(String)
        return !attribute.empty?
      end

      if attribute.kind_of?(Date)
        return !attribute.nil?
      end

      false
    end

    def self.present?(attribute)
      return attribute && !attribute.empty? if defined?(attribute) && defined?(attribute.empty?)
      return attribute
    end

    def self.initials(name)
      name.split(" ").map { |part| part[0].capitalize }.join(".")
    end

    # This is following the specs for APA like
    def self.combine_authors(authors)
      return authors.first if authors.length === 1

      return "#{authors.first} & #{authors.last}" if authors.length === 2

      return "#{authors[0..authors.length - 1].join(", ")} & #{authors.last}" if authors.length > 2 && authors.length <= 5
    end
  end
end
