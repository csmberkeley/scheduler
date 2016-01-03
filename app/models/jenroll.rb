class Jenroll < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
	belongs_to :section
	has_many :attendances, dependent: :destroy
	has_many :senrolls, :through => :mentorjoins
	has_many :mentorjoins
end
