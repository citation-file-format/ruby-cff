# frozen_string_literal: true

module CFF

  # Formatter base class
  class Formatter

    def self.required_fields?(model)
      !(model.authors.empty? || !date_present?(model.date_released) || model.title.empty? || model.version.empty?)
    end

    def self.format_author(author) # rubocop:disable Metrics/AbcSize
      if author.is_a?(Person)
        output = +''
        output << "#{author.name_particle} " if present?(author.name_particle)
        output << author.family_names if present?(author.family_names)
        output << " #{author.name_suffix}" if present?(author.name_suffix)
        output << " #{initials(author.given_names)}" if present?(author.given_names)
        return output
      end

      return author.name if author.is_a?(Entity)
    end

    def self.date_present?(attribute)
      return !attribute.empty? if attribute.is_a?(String)

      return !attribute.nil? if attribute.is_a?(Date)

      false
    end

    def self.present?(attribute)
      return attribute && !attribute.empty? if defined?(attribute) && defined?(attribute.empty?)

      attribute
    end

    def self.initials(name)
      name.split.map { |part| part[0].capitalize }.join('.')
    end

    # This is following the specs for APA like
    def self.combine_authors(authors)
      return authors.first if authors.length == 1

      return "#{authors.first} & #{authors.last}" if authors.length == 2

      "#{authors[0..authors.length - 1].join(', ')} & #{authors.last}" if authors.length > 2 && authors.length <= 5
    end
  end
end
