module DomainMappedAttribute
  class DomainMapper

    attr_reader :resolver
    delegate :resolve, to: :resolver

    def initialize(name_field, options = {})
      resolver_class = options.fetch(:resolver_class, Resolver)
      @resolver = resolver_class.new({
        name_field: name_field,
        options: options,
        klass: options.delete(:klass)
      })
    end

  end
end
