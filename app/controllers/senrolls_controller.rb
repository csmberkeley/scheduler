class SenrollsController < ApplicationController
    before_filter :check_logged_in
    before_filter :check_senroll, :only => [:destroy, :switch, :update_switch, :edit, :update, :destroy_temp_location, :destroy_temp_time, :roster]
    before_filter :check_update_switch, :only => [:update_switch]

	def destroy
    	@senroll = Senroll.find(params[:id])
    	@senroll.destroy
    	flash[:notice] = "You are no longer mentoring that section."
    	redirect_to root_path
    end

    def switch
    	@senroll = Senroll.find(params[:id])
    	@course = Course.find(@senroll.course_id)
		@sections = Section.getSectionsWithoutMentor(@course)
    end

    def update_switch
        @senroll = Senroll.find(params[:id])
        @section = @senroll.section
        @section.temp_start = nil
        @section.temp_end = nil
        @section.temp_location = nil
        @section.temp_date = ""
        @section.save
        if @senroll.update_attributes(senroll_params)
            flash[:notice] = "Switched your mentoring section!"
            redirect_to root_path
        else
            flash[:notice] = "Something went wrong. Please try again later."
            redirect_to root_path
        end
    end

    def edit
        @senroll = Senroll.find(params[:id])
        @section = Section.find(@senroll.section_id)
    end

    def update
        @senroll = Senroll.find(params[:id])
        @section = Section.find(@senroll.section_id)
        @new_section = Section.new(senroll_section_params)
        time_change = false
        location_change = false
        if @new_section.temp_start != nil and @new_section.temp_end != nil and @new_section.temp_date != ""
            if params["makeDefaultTime?"]
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
            redirect_to edit_senroll_path(@senroll)
            return
        end

        if @new_section.temp_location != ""
            if params["makeDefaultLocation?"]
                @section.location = @new_section.temp_location
            end
            @section.temp_location = @new_section.temp_location
            location_change = true
        end
        if params["notify?"] and (location_change or time_change)
            #mail
            users = []
            users << User.find(@senroll.user_id)
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
        @senroll = Senroll.find(params[:id])
        @section = Section.find(@senroll.section_id)
        @user = @senroll.user
        @section.temp_location = nil
        UserMailer.location_remove_email(@user, @section).deliver
        if @section.save
            flash[:notice] = "Temporary location change removed."
        else
            flash[:notice] = "Something went wrong. Please try again later."
        end
        redirect_to edit_senroll_path(@senroll)
    end

    def destroy_temp_time
        @senroll = Senroll.find(params[:id])
        @section = Section.find(@senroll.section_id)
        @user = @senroll.user
        @section.temp_start = nil
        @section.temp_end = nil
        @section.temp_date = ""
        UserMailer.time_remove_email(@user, @section).deliver
        if @section.save
            flash[:notice] = "Temporary time change removed."
        else
            flash[:notice] = "Something went wrong. Please try again later."
        end
        redirect_to edit_senroll_path(@senroll) 
    end

    def roster
    	@senroll = Senroll.find(params[:id])
    	@students = @senroll.getStudents()
        @email_list = ""
        @students.each_with_index do |student, i| 
            if i == 0
                @email_list << student.email
            else
                @email_list << ", #{student.email}"
            end
        end
        render "jenrolls/roster"
    end

    private
	def senroll_params
		params.require(:senroll).permit(:section_id)
	end

    private
    def senroll_section_params
        params.require(:section).permit(:temp_start, :temp_end, :temp_location, :temp_date)
    end

    #before filters
    private
    def check_senroll
        if not params[:id] or not Senroll.exists?(params[:id]) or not check_enrollment(Senroll.find(params[:id]))
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
        if params[:senroll]
            senroll = Senroll.new(senroll_params)
            if senroll.section_id and Section.exists?(senroll.section_id)
                return
            end
        end
        flash[:notice] = "Please choose a section."
        redirect_to :back
    end

end
