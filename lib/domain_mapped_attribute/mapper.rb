module DomainMappedAttribute
  class Mapper
    attr_reader :before_validator, :presence_validator

    def initialize(association_name, association_klass, options = {})

      @allow_blank = !!options.fetch(:allow_blank, false)
      @column_name = options.fetch(:attribute_object_name_field, :name)

      attribute_name_field = "#{association_name}_name"
      attribute_object_id_field = "#{association_name}_id"
    end
    #
    # # overwrite the reader to show the real value or the mapped attribute value as a backup
    # define_method(attribute_name_field) do
    #   # return the user input value if it's present
    #   return read_attribute(attribute_name_field) if attribute_present?(attribute_name_field)
    #
    #   # follow the association and return the name
    #   if obj = self.send(attribute_object_field)
    #     return nil if obj.unknown?
    #     obj.send(attribute_object_field)
    #   end
    #
    #   nil
    #   return self.send(attribute_object_field).send(attribute_object_name_field) unless self.send(attribute_object_field).nil? || self.send(attribute_object_id_field) == object_klass.const_get(:UNKNOWN) || (object_klass.const_defined?(:GENERIC_VALUES) && object_klass.const_get(:GENERIC_VALUES).and.include?(self.send(attribute_object_id_field)))
    #   return nil
    # end

  end
end
