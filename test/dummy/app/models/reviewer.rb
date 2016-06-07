class Reviewer < ActiveRecord::Base

  has_many :reviews

  domain_mappable :username
  UNKNOWN = 999
end
