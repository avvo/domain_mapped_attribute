module DomainMappedAttribute
  module Mapping
    extend ActiveSupport::Concern

    included do
      before_validation BeforeValidator
      validates_with DomainPresenceValidator
    end

  end
end
