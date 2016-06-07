module DomainMappedAttribute

  class DomainPresenceValidator < ActiveModel::EachValidator

    def validate_each(record, attribute, value)
      name_field = "#{attribute}_name"
      id_field = "#{attribute}_id"

      # allow if record has name field set
      return true if record.read_attribute(name_field).present?

      # allow if there is a mapped value that is not "unknown"
      domain_id = record.read_attribute(id_field)
      return true if domain_id.present? && !record.class.unknown_domain_value?(domain_id)

      # the id value is "unknown" and the name field is blank
      record.errors.add(name_field, :blank)
    end
  end

end
