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
			current_user.jenrolls << @jenroll
			@course.jenrolls << @jenroll
			@section.assignMentor(@jenroll)
			flash[:notice] = "You have been signed up as a mentor!"
			redirect_to root_path
		else 
	  		flash[:notice] = "Invalid mentor password!"
	  		redirect_to root_path
	  	end
    end
    def destroy
    	@jenroll = Jenroll.find(params[:id])
    	@jenroll.destroy
    	flash[:notice] = "You are no longer mentoring that section."
    	redirect_to root_path
    end

    def edit
    	@jenroll = Jenroll.find(params[:id])
    	@course = Course.find(@jenroll.course_id)
		@sections = Section.getSectionsWithoutMentor(@course)
    end
    def update
    	@jenroll = Jenroll.find(params[:id])
    	if @jenroll.update_attributes(jenroll_params)
    		flash[:notice] = "Switched the section you're mentoring for."
    		redirect_to root_path
    	else
    		flash[:notice] = "Something went wrong. Please try again later."
    		redirect_to root_path
    	end
    end

    def roster
    	@jenroll = Jenroll.find(params[:id])
    	@students = @jenroll.getStudents()
        @email_list = ""
        @students.each_with_index do |student, i| 
            if i == 0
                @email_list << student.email
            else
                @email_list << ", #{student.email}"
            end
        end
    end

    private
	def jenroll_params
		params.require(:jenroll).permit(:section_id)
	end
end
