module DomainMappedAttribute

  module ResolveMethods
    def domain_mapped_resolver
      @domain_mapped_resolver ||= begin
        klass = self.domain_mapped_options[:resolver_class] ||
                DomainMappedAttribute.config[:resolver_class]
        klass.new({
          name_field: self.domain_mapped_resolver_field,
          options:    self.domain_mapped_options,
          logger:     self.logger,
          klass:      self,
        })
      end
    end

    def resolve(name, options = {})
      self.domain_mapped_resolver.resolve(name, options)
    end
  end

end
