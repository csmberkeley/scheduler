class CoursesController < ApplicationController
	def index
		@courses = []
		current_user.enrolls.each do |e|
			curr_course = Course.find(e.course_id)
			@courses << curr_course
		end
	end
	def show
		@course = Course.find(params[:id])
	end
end
