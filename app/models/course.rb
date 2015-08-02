class Course < ActiveRecord::Base
  has_many :enrolls, dependent: :destroy
end
