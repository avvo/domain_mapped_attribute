class Restaurant < ActiveRecord::Base
  has_many :reviews

  include DomainMappedAttribute::DomainMappable

  domain_mappable :name
end
