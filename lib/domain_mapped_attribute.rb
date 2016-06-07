require "domain_mapped_attribute/version"

module DomainMappedAttribute
  autoload :BeforeValidator, "domain_mapped_attribute/before_validator"
  autoload :DomainMapper, "domain_mapped_attribute/domain_mapper"
  autoload :DomainPresenceValidator, "domain_mapped_attribute/domain_presence_validator"
  autoload :Resolver, "domain_mapped_attribute/resolver"

  extend ActiveSupport::Concern

  included do
    puts "included in AR::Base"
  end

  module ClassMethods
    def domain_mapped_attribute(association_name, association_class, options = {})
      name_field = options[:name_field] ||= "#{association_name}_name"
      options[:id_field] ||= "#{association_name}_id"
      options[:association_class] ||= association_class

      # the before validator does the mapping
      before_validation BeforeValidator.new(association_class, options)
      validates association_name, domain_presence: options

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

# require "domain_presence_validator"
require "domain_mapped_attribute/railtie" if defined?(Rails)
