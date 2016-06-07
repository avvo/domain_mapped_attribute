module DomainMappedAttribute
  module DomainMappable
    extend ActiveSupport::Concern

    module ClassMethods
      def domain_mapped_attribute(attribute_object_field, object_klass, options = {})
        allow_blank = !!options.fetch(:allow_blank, false)
        attribute_object_name_field = options.fetch(:attribute_object_name_field, :name)
        attribute_name_field = "#{attribute_object_field}_name"
        attribute_object_id_field = "#{attribute_object_field}_id"

        @domain_mapped_attributes ||= {}
        @domain_mapped_attributes[attribute_object_field] = {
          name_field:         attribute_name_field.to_sym,
          object_id_field:    attribute_object_id_field,
          object_class:       object_klass,
          object_name_field:  attribute_object_name_field
        }

        # setup validator that does the resolving on save
        domain_mapping_validator = DomainMappedAttribute::BeforeValidator.new({
          klass:            object_klass,
          name_field:       attribute_name_field,
          object_id_field:  attribute_object_id_field,
        })
        before_validation domain_mapping_validator

        # overwrite the reader to show the real value or the mapped attribute value as a backup
        define_method(attribute_name_field) do
          return read_attribute(attribute_name_field) if attribute_present?(attribute_name_field)
          return self.send(attribute_object_field).send(attribute_object_name_field) unless self.send(attribute_object_field).nil? || self.send(attribute_object_id_field) == object_klass.const_get(:UNKNOWN) || (object_klass.const_defined?(:GENERIC_VALUES) && object_klass.const_get(:GENERIC_VALUES).and.include?(self.send(attribute_object_id_field)))
          return nil
        end

        unless method_defined?("resolve_options")
          define_method("resolve_options") do
            return {}
          end
        end

        # validate presence of name field unless options[:allow_blank]
        validate do |record|
          id_value = record.send(attribute_object_id_field)
          name_value = record.attributes[attribute_name_field.to_s]

          unless allow_blank
            if !object_klass.id_set_and_not_unknown(id_value) && name_value.blank?
              record.errors.add(attribute_name_field, :blank)
            end
          end
        end
      end

      def domain_mappable(name_field, options = {})
        cattr_accessor :domain_mapped_resolver_field
        cattr_accessor :domain_mapped_options
        self.domain_mapped_resolver_field = name_field
        self.domain_mapped_options = options
        self.extend(DomainMappedAttribute::ResolveMethods)
      end

      def domain_mapped_attributes
        @domain_mapped_attributes ||= {}
      end
    end

  end
end
