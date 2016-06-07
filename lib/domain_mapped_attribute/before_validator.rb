module DomainMappedAttribute

  class BeforeValidator
    def initialize(options = {})
      @klass = options[:klass]
      @name_field = options[:name_field]
      @object_id_field = options[:object_id_field]
      @unknown_id = @klass.const_get(:UNKNOWN)
    end

    def before_validation(model)
      # make sure we're set to unknown initially if it's not set (could be nil or 0)
      unless @klass.id_set_and_not_unknown(model.send(@object_id_field))
        model.send("#{@object_id_field}=", @unknown_id)
      end

      # set the id to unknown if the name has changed to something other than nil -- this will force a resolve
      if model.changed.include?(@name_field) && model.attribute_present?(@name_field)
        model.send("#{@object_id_field}=", @unknown_id)
      end

      # if the id is unknown and we have a name, try to resolve it...
      if model.read_attribute(@object_id_field) == @unknown_id && model.attribute_present?(@name_field)
        resolved_id = @klass.resolve(model.read_attribute(@name_field), model.resolve_options)
        model.send("#{@object_id_field}=", resolved_id) if resolved_id.present?
      end
    end
  end

end
