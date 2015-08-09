class Course < ActiveRecord::Base
  has_many :enrolls, dependent: :destroy
  has_many :sections, dependent: :destroy
end
