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
            if params.has_key?("sm?")
                @senroll = Senroll.new
                current_user.senrolls << @senroll
                @course.senrolls << @senroll
                @section.assignMentor(@senroll)
            else
                @jenroll = Jenroll.new
                current_user.jenrolls << @jenroll
                @course.jenrolls << @jenroll
                @section.assignMentor(@jenroll)
            end
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

    def switch
        @jenroll = Jenroll.find(params[:id])
        @course = Course.find(@jenroll.course_id)
        @sections = Section.getSectionsWithoutMentor(@course)
    end

    def update_switch
        @jenroll = Jenroll.find(params[:id])
        if @jenroll.update_attributes(jenroll_params)
            flash[:notice] = "Switched the section you're mentoring for."
            redirect_to root_path
        else
            flash[:notice] = "Something went wrong. Please try again later."
            redirect_to root_path
        end
    end

    def edit
    	@jenroll = Jenroll.find(params[:id])
    	@section = Section.find(@jenroll.section_id)
    end
    def update
    	@jenroll = Jenroll.find(params[:id])
        @section = Section.find(@jenroll.section_id)
        @new_section = Section.new(jenroll_section_params)
        if @new_section.temp_start != nil and @new_section.temp_end != nil and @new_section.temp_date != ""
            if params["makeDefaultTime?"]
                @section.start = @new_section.temp_start
                @section.end = @new_section.temp_end
                @section.date = @new_section.temp_date
            end
            @section.temp_start = @new_section.temp_start
            @section.temp_end = @new_section.temp_end
            @section.temp_date = @new_section.temp_date
        elsif @new_section.temp_start != nil or @new_section.temp_end != nil or @new_section.temp_date != ""
            #missing fields
            flash[:notice] = "Missing fields for new section."
            redirect_to edit_jenroll_path(@jenroll)
            return
        end

        if @new_section.temp_location != ""
            if params["makeDefaultLocation?"]
                @section.location = @new_section.temp_location
            end
            @section.temp_location = @new_section.temp_location
        end
    	if @section.save
    		flash[:notice] = "Your mentor settings have been saved!"
    		redirect_to root_path
    	else
    		flash[:notice] = "Something went wrong. Please try again later."
    		redirect_to root_path
    	end
    end

    def destroy_temp_location
        @jenroll = Jenroll.find(params[:id])
        @section = Section.find(@jenroll.section_id)
        @section.temp_location = nil
        if @section.save
            flash[:notice] = "Temporary location change removed."
        else
            flash[:notice] = "Something went wrong. Please try again later."
        end
        redirect_to edit_jenroll_path(@jenroll)
    end

    def destroy_temp_time
        @jenroll = Jenroll.find(params[:id])
        @section = Section.find(@jenroll.section_id)
        @section.temp_start = nil
        @section.temp_end = nil
        @section.temp_date = ""
        if @section.save
            flash[:notice] = "Temporary time change removed."
        else
            flash[:notice] = "Something went wrong. Please try again later."
        end
        redirect_to edit_jenroll_path(@jenroll) 
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

    private
    def jenroll_section_params
        params.require(:section).permit(:temp_start, :temp_end, :temp_location, :temp_date)
    end
end
