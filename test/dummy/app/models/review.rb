class Review < ActiveRecord::Base
  belongs_to :restaurant

  include DomainMappedAttribute::DomainMappable

  domain_mapped_attribute :restaurant, Restaurant
end
