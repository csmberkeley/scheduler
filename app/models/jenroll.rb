class Jenroll < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
	belongs_to :section
	belongs_to :senroll
	has_many :attendances


	def getStudents()
		@section = Section.find(self.section_id)
		users = []
		@section.enrolls.each do |enroll|
			curr_user = User.find(enroll.user_id)
			users << curr_user
		end
		return users
	end
end
