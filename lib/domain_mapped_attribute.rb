require "domain_mapped_attribute/version"

module DomainMappedAttribute
  autoload :BeforeValidator, "domain_mapped_attribute/before_validator"
  autoload :Configuration, "domain_mapped_attribute/configuration"
  autoload :DomainMapper, "domain_mapped_attribute/domain_mapper"
  autoload :DomainPresenceValidator, "domain_mapped_attribute/domain_presence_validator"
  autoload :Mapping, "domain_mapped_attribute/mapping"
  autoload :Resolver, "domain_mapped_attribute/resolver"

  extend ActiveSupport::Concern

  module ClassMethods
    def domain_mapped_attribute_config
      @domain_mapped_attribute_config ||= Configuration.new
    end

    def domain_mapped_attribute(association_name, association_class, options = {})
      attribute = domain_mapped_attribute_config.add_attribute(association_name, association_class, options)
      name_field = attribute.name_field

      # use a mixin to only run stuff once
      include Mapping

      # overwrite the reader for the name
      define_method(name_field) do
        return read_attribute(name_field) if attribute_present?(name_field)

        send(association_name).tap do |obj|
          return nil if obj.nil?
          return nil if association_class.unknown_domain_value?(obj.id)

          return obj.name
        end
      end
    end

    def domain_mappable(name_field, options = {})
      cattr_accessor :domain_mapper
      self.domain_mapper = DomainMapper.new(name_field, options.merge(klass: self))

      class << self
        delegate :resolve, to: :domain_mapper

        def unknown_domain_id
          const_defined?(:UNKNOWN) ? const_get(:UNKNOWN) : nil
        end

        def unknown_domain_value?(value)
          unknown_domain_id == value
        end
      end

    end

  end
end

ActiveSupport.on_load(:active_record) do
  include ::DomainMappedAttribute
end
