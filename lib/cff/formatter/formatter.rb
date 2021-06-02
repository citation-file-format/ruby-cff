# frozen_string_literal: true

module CFF
  # Formatter base class
  class Formatter
    def self.required_fields?(model)
      !((model.authors.empty? && model.references.empty?) || model.title.empty? || model.version.to_s.empty?)
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

    def self.combine_authors(authors)
      raise NotImplementedError
    end

    def self.try_get_year(value)
      if value.instance_of? Date
        value.year
      else
        begin
          date = Date.parse(value)
          date.year.to_s
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
