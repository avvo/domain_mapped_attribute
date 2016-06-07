module DomainMappedAttribute

  module ResolveMethods
    def domain_mapped_resolver
      @domain_mapped_resolver ||= begin
        klass = domain_mapped_options.fetch(:resolver_class, DomainMappedAttribute.config[:resolver_class])
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

    def unknown_domain_id
      const_defined?(:UNKNOWN) ? const_get(:UNKNOWN) : nil
    end

    def unknown_domain_value?(value)
      unknown_domain_id == value
    end

  end

end
