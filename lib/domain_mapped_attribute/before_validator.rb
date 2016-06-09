module DomainMappedAttribute

  class BeforeValidator
    delegate :name_field, :id_field, :domain_class, to: :@attribute

    def self.before_validation(record)
      record.class.domain_mapped_attribute_config.each do |_, attribute|
        new(attribute).before_validation(record)
      end
    end

    def initialize(attribute)
      @attribute = attribute
    end

    def before_validation(record)
      reset_id_field(record) if should_reset?(record)

      # if the id is unknown and we have a name, try to resolve it...
      return unless should_resolve?(record)

      resolve_options = record.respond_to?(:resolve_options) ? record.resolve_options : {}
      resolved_id = domain_class.resolve(record.read_attribute(name_field), resolve_options)
      set_id(record, resolved_id) if resolved_id.present?
    end

    protected

    def should_reset?(record)
      # if the id is already set
      return true unless record.attribute_present?(id_field)

      # name was changed to something other than nil
      record.changed.include?(name_field) &&
        record.attribute_present?(name_field)
    end

    def should_resolve?(record)
      domain_class.unknown_domain_value?(record.read_attribute(id_field)) &&
        record.attribute_present?(name_field)
    end

    def reset_id_field(record)
      set_id(record, domain_class.unknown_domain_id)
    end

    def set_id(record, value)
      record.send("#{id_field}=", value)
    end

  end

end
