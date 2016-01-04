class Senroll < ActiveRecord::Base
	has_many :jenrolls
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
