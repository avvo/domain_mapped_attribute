module DomainMappedAttribute

  class Resolver
    def initialize(options = {})
      @name_field = options[:name_field]
      @klass = options[:klass]
    end

    def resolve(name, options = {})
      conditions = options.select{|k,v| @klass.column_names.include?(k.to_s)}
      matches = @klass.where(@name_field => name).where(conditions)
      if matches.length > 0
        return matches[0].id
      else
        return @klass.unknown_domain_id
      end
    end
  end

end
