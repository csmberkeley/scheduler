class JenrollsController < ApplicationController
	def new
        @courses = Course.all
	end

	def mentor_enroll
		@course = Course.find(params[:course_id])
		@sections = Section.getSectionsWithoutMentor(@course)
	end

    def create
	    password = params[:pass]
	    @section = Section.find(params[:section_id])
	    @course = @section.course
		if password == @course.password
			@jenroll = Jenroll.new
			@section.assignMentor(@jenroll)
			flash[:notice] = "You have been signed up as a mentor!"
			redirect_to root_path
		else 
	  		flash[:notice] = "Invalid mentor password!"
	  		redirect_to root_path
	  	end

    end
end
