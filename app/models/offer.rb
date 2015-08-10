class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_many :replies, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :comments, dependent: :destroy 
end
