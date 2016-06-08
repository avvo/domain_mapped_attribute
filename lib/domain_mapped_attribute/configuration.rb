module DomainMappedAttribute
  class Configuration
    Attribute = Struct.new(:id_field, :name_field, :domain_class, :domain_name_field, :allow_blank)
    delegate :each, to: :@attributes

    def initialize
      @attributes = {}
    end

    def add_attribute(association_name, domain_class, options = {})
      name_field = options.fetch(:name_field, "#{association_name}_name")
      id_field = options.fetch(:id_field, "#{association_name}_id")
      allow_blank = options.fetch(:allow_blank, false)
      domain_name_field = options.fetch(:domain_name_field, :name)

      @attributes[association_name] = Attribute.new(id_field, name_field, domain_class, domain_name_field, allow_blank)
    end
  end
end
