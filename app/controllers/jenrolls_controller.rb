class JenrollsController < ApplicationController
    before_filter :check_logged_in
    before_filter :check_mentor_enroll, :only => [:mentor_enroll_redirect]
    before_filter :check_create, :only => [:create]
    before_filter :check_jenroll, :only => [:destroy, :switch, :update_switch, :edit, :update, :destroy_temp_location, :destroy_temp_time, :roster]
    before_filter :check_update_switch, :only => [:update_switch]

	def new
        if not current_user.mentor_verified
            flash[:notice] = "Please agree to the contract to be a mentor!"
            redirect_to contract_path(current_user)
            return
        end
        @courses = Course.all
	end

    def mentor_enroll_redirect
        @course = Course.find(params[:course_id])
        redirect_to mentor_enroll_path(course_id: @course.id)
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
	  		redirect_to :back
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
        @section = @jenroll.section
        @section.temp_start = nil
        @section.temp_end = nil
        @section.temp_location = nil
        @section.temp_date = ""
        @section.save
        if @jenroll.update_attributes(jenroll_params)
            flash[:notice] = "Switched your mentoring section!"
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
        time_change = false
        location_change = false
        if @new_section.temp_start != nil and @new_section.temp_end != nil and @new_section.temp_date != ""
            if params["makeDefaultTime?"] and (Setting.find_by(name: 'default_switching').value == "1" or current_user.admin)
                @section.start = @new_section.temp_start
                @section.end = @new_section.temp_end
                @section.date = @new_section.temp_date
            end
            @section.temp_start = @new_section.temp_start
            @section.temp_end = @new_section.temp_end
            @section.temp_date = @new_section.temp_date
            time_change = true
        elsif @new_section.temp_start != nil or @new_section.temp_end != nil or @new_section.temp_date != ""
            #missing fields
            flash[:notice] = "Missing fields for new section."
            redirect_to edit_jenroll_path(@jenroll)
            return
        end

        if @new_section.temp_location != ""
            if params["makeDefaultLocation?"] and (Setting.find_by(name: 'default_switching').value == "1" or current_user.admin)
                @section.location = @new_section.temp_location
            end
            @section.temp_location = @new_section.temp_location
            location_change = true
        end
        if params["notify?"] and (location_change or time_change)
            #mail
            users = []
            users << User.find(@jenroll.user_id)
            @section.enrolls.each do |enroll|
                users << User.find(enroll.user_id)
            end
            users.each do |user|
                #uncomment when working
                UserMailer.timeloc_change_email(user, @section, time_change, location_change).deliver
            end
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
        @user = @jenroll.user
        @section.temp_location = nil
        UserMailer.location_remove_email(@user, @section).deliver
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
        @user = @jenroll.user
        @section.temp_start = nil
        @section.temp_end = nil
        @section.temp_date = ""
        UserMailer.time_remove_email(@user, @section).deliver
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

    #before filters
    private
    def check_jenroll
        if not params[:id] or not Jenroll.exists?(params[:id]) or not (check_enrollment(Jenroll.find(params[:id])) or current_user.admin)
            flash[:notice] = "You do not have permission to access that page."
            redirect_to root_path
        end
    end

    private
    def check_mentor_enroll
        if not params[:course_id]
            flash[:notice] = "Please choose a course."
            redirect_to new_jenroll_path
        end
    end

    private
    def check_create
        if params[:pass] == ""
            flash[:notice] = "Please enter in the password."
            redirect_to :back
            return
        end
        if not params[:section_id]
            flash[:notice] = "Please choose a section."
            redirect_to :back
            return
        end
    end

    private
    def check_update_switch
        if params[:jenroll]
            jenroll = Jenroll.new(jenroll_params)
            if jenroll.section_id and Section.exists?(jenroll.section_id)
                return
            end
        end
        flash[:notice] = "Please choose a section."
        redirect_to :back
    end
end
