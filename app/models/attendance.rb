class Attendance < ActiveRecord::Base
	belongs_to :enroll
	belongs_to :jenroll
	belongs_to :senroll

	enum status: [ :approved, :pending, :denied, :excused ]

  def self.nil_statuses
    Attendance.statuses.keys.to_a.unshift("Change attendance...")
  end
end
