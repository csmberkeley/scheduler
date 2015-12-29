class Course < ActiveRecord::Base
  has_many :enrolls, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :jenrolls, dependent: :destroy
  has_many :senrolls, dependent: :destroy
end
