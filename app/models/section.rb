class Section < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  #Note: Don't want to delete users from database even if section is destroyed 
  has_many :users 
  has_many :requests, dependent: :destroy
  has_many :offers, dependent: :destroy
end
