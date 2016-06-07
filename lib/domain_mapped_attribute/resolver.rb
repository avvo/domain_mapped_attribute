module DomainMappedAttribute

  class Resolver
    def initialize(options = {})
      @name_field = options[:name_field]
      @logger = options[:logger]
      @klass = options[:klass]
      @options = options[:options]
    end

    def resolve(name, options = {})
      conditions = options.merge({@name_field => name})
      conditions.reject!{|k,v| !@klass.column_names.include?(k.to_s)}
      matches = @klass.where(conditions)
      if matches.length > 0
        return matches[0].id
      else
        return @klass.unknown_domain_id
      end
    end
  end

end
