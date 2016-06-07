module DomainMappedAttribute

  class BeforeValidator
    attr_reader :name_field, :id_field

    def initialize(association_name, association_klass)
      @klass = association_klass
      @name_field = "#{association_name}_name"
      @id_field = "#{association_name}_id"
    end

    def before_validation(record)
      reset_id_field(record) if should_reset?(record)

      # if the id is unknown and we have a name, try to resolve it...
      return unless should_resolve?(record)

      resolved_id = @klass.resolve(record.read_attribute(name_field), record.resolve_options)
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
      @klass.unknown_domain_value?(record.read_attribute(id_field)) &&
        record.attribute_present?(name_field)
    end

    def reset_id_field(record)
      set_id(record, @klass.unknown_domain_id)
    end

    def set_id(record, value)
      record.send("#{id_field}=", value)
    end

  end

end
