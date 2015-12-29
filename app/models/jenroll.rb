class Jenroll < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
	belongs_to :section
	belongs_to :senroll
	has_many :attendances
end
