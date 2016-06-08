module DomainMappedAttribute
  class DomainPresenceValidator
    def initialize(*); end

    def validate(record)
      record.class.domain_mapped_attribute_config.each do |_, attribute|
        validate_attribute(record, attribute)
      end
    end

    def validate_attribute(record, attribute)
      return true if attribute.allow_blank

      name_field = attribute.name_field
      id_field = attribute.id_field

      # allow if record has name field set
      return true if record.read_attribute(name_field).present?

      # allow if there is a mapped value that is not "unknown"
      domain_id = record.read_attribute(id_field)
      association_class = attribute.association_class
      return true if domain_id.present? && !association_class.unknown_domain_value?(domain_id)

      # the id value is "unknown" and the name field is blank
      record.errors.add(name_field, :blank)
    end
  end
end
