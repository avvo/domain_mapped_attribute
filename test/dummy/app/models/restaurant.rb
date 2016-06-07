class Restaurant < ActiveRecord::Base
  has_many :reviews

  domain_mappable :name
end
