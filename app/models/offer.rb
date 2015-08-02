class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_many :replies 
end
