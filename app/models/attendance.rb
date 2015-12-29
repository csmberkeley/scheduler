class Attendance < ActiveRecord::Base
	belongs_to :enroll
	belongs_to :jenroll
	belongs_to :senroll

	enum status: [ :approved, :pending, :denied, :excused ]
end
