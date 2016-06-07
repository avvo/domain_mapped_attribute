require "domain_mapped_attribute/version"

module DomainMappedAttribute
  autoload :BeforeValidator, "domain_mapped_attribute/before_validator"
  autoload :DomainPresenceValidator, "domain_mapped_attribute/domain_presence_validator"
  autoload :ResolveMethods, "domain_mapped_attribute/resolve_methods"
  autoload :Resolver, "domain_mapped_attribute/resolver"

  mattr_accessor :config
  self.config = {
    resolver_class: DomainMappedAttribute::Resolver
  }

  extend ActiveSupport::Concern

  included do
    puts "included in AR::Base"
  end

  module ClassMethods
    def domain_mapped_attribute(association_name, association_klass, options = {})
      name_field = options[:name_field] ||= "#{association_name}_name"
      options[:id_field] ||= "#{association_name}_id"

      # the before validator does the mapping
      before_validation BeforeValidator.new(association_klass, options)
      validates association_name, domain_presence: options

      # overwrite the reader for the name
      define_method(name_field) do
        return read_attribute(name_field) if attribute_present?(name_field)

        send(association_name).tap do |obj|
          return nil if obj.nil?
          return nil if association_klass.unknown_domain_value?(obj.id)

          return obj.name
        end
      end
    end

    def domain_mappable(name_field, options = {})
      cattr_accessor :domain_mapped_resolver_field
      cattr_accessor :domain_mapped_options
      self.domain_mapped_resolver_field = name_field
      self.domain_mapped_options = options

      extend DomainMappedAttribute::ResolveMethods
    end

    def domain_mapped_attributes
      @domain_mapped_attributes ||= {}
    end
  end
end

# require "domain_presence_validator"
require "domain_mapped_attribute/railtie" if defined?(Rails)
