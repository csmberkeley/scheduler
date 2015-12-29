class Senroll < ActiveRecord::Base
	has_many :jenrolls
	has_many :attendances
end
