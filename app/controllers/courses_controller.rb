class CoursesController < ApplicationController
	def index
		@courses = []
		puts current_user.enrolls
		current_user.enrolls.each do |e|
			curr_course = Course.find(e.course_id)
			@courses << curr_course
		end
		puts "THESE ARE"
		puts @courses
	end
	def show
		@course = Course.find(params[:id])
	end
end
