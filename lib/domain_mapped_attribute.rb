require "domain_mapped_attribute/version"

module DomainMappedAttribute
  autoload :BeforeValidator, "domain_mapped_attribute/before_validator"
  autoload :DomainMappable, "domain_mapped_attribute/domain_mappable"
  autoload :ResolveMethods, "domain_mapped_attribute/resolve_methods"
  autoload :Resolver, "domain_mapped_attribute/resolver"

  mattr_accessor :config
  self.config = {
    resolver_class: DomainMappedAttribute::Resolver
  }
end
