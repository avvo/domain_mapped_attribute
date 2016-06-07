require "domain_mapped_attribute/version"

module DomainMappedAttribute
  autoload :BeforeValidator, "domain_mapped_attribute/before_validator"
  autoload :DomainMappable, "domain_mapped_attribute/domain_mappable"
  autoload :Mapper, "domain_mapped_attribute/mapper"
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
      # the before validator does the mapping
      before_validation BeforeValidator.new(association_name, association_klass)
      validates association_name, domain_presence: {allow_blank: !!options.delete(:allow_blank)}

      unless method_defined?("resolve_options")
        define_method("resolve_options") do
          return {}
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
