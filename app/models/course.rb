class Course < ActiveRecord::Base
  has_many :enrolls, dependent: :destroy
  has_many :topics, dependent: :destroy
end
