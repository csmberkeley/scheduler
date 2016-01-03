class Senroll < ActiveRecord::Base
	has_many :attendances, dependent: :destroy
	has_many :jenrolls, :through => :mentorjoins
	has_many :mentorjoins
end
