class Restaurant < ActiveRecord::Base
  has_many :reviews

  domain_mappable :name
  UNKNOWN = 1
end
