module DomainMappedAttribute

  class BeforeValidator
    attr_reader :name_field, :id_field

    def initialize(association_klass, options = {})
      @klass = association_klass
      @name_field = options[:name_field]
      @id_field = options[:id_field]
    end

    def before_validation(record)
      reset_id_field(record) if should_reset?(record)

      # if the id is unknown and we have a name, try to resolve it...
      return unless should_resolve?(record)

      resolve_options = record.respond_to?(:resolve_options) ? record.resolve_options : {}
      resolved_id = @klass.resolve(record.read_attribute(name_field), resolve_options)
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
