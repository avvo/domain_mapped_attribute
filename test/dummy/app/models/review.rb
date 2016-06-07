class Review < ActiveRecord::Base
  belongs_to :restaurant

  domain_mapped_attribute :restaurant, Restaurant
end
