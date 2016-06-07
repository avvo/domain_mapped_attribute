module DomainMappedAttribute
  class Railtie < ::Rails::Railtie

    initializer "domain_mapped_attribute.active_record" do |app|
      ActiveSupport.on_load(:active_record) do
        include ::DomainMappedAttribute
      end
    end

  end
end
