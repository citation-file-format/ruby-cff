# frozen_string_literal: true

module CFF
  # Formatter base class
  class Formatter

    def self.required_fields?(model)
      !(model.authors.empty? || model.title.empty? || model.version.to_s.empty?)
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

    def self.try_get_month(value)
      if value.instance_of? Date
        value.month
      else
        begin
          date = Date.parse(value.to_s)
          date.month.to_s
        rescue ArgumentError
          nil
        end
      end
    end

    def self.try_get_year(value)
      if value.instance_of? Date
        value.year
      else
        begin
          date = Date.parse(value.to_s)
          date.year.to_s
        rescue ArgumentError
          nil
        end
      end
    end
  end
end
