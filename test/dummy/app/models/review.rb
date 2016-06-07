class Review < ActiveRecord::Base
  belongs_to :restaurant
  belongs_to :reviewer

  domain_mapped_attribute :restaurant, Restaurant
  domain_mapped_attribute :reviewer, Reviewer, name_field: :reviewed_by
end
