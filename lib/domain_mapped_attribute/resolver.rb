module DomainMappedAttribute

  class Resolver < Struct.new(:options)

    def resolve(name, query = {})
      conditions = query.select{|k,v| domain_class.column_names.include?(k.to_s)}
      matches = domain_class.where(name_field => name).where(conditions).to_a
      if matches.present?
        return matches.first.id
      else
        return unknown_domain_id
      end
    end

    protected

    def name_field
      options.fetch(:name_field)
    end

    def domain_class
      options.fetch(:domain_class)
    end

    def unknown_domain_id
      domain_class.unknown_domain_id
    end
  end

end
