module DomainMappedAttribute

  class DomainPresenceValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      return true if options[:allow_blank]

      name_field = options.fetch(:name_field)
      id_field = options.fetch(:id_field)

      # allow if record has name field set
      return true if record.read_attribute(name_field).present?

      # allow if there is a mapped value that is not "unknown"
      domain_id = record.read_attribute(id_field)
      association_class = options.fetch(:association_class)
      return true if domain_id.present? && !association_class.unknown_domain_value?(domain_id)

      # the id value is "unknown" and the name field is blank
      record.errors.add(name_field, :blank)
    end
  end

end
