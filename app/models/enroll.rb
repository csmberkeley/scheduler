class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :courses
  belongs_to :section
end
