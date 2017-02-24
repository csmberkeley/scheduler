class AttendancesController < ApplicationController
    before_filter :check_logged_in
    before_filter :check_student_access, :only => [:show]
    before_filter :check_student_create_access, :only => [:checkin, :create]
    before_filter :check_junior_mentor_access, :only => [:mentor_show]
    before_filter :check_senior_mentor_access, :only => [:mentor_show_senior]
    before_filter :check_mentor_section_access, :only => [:set_pass]
    before_filter :check_owns_student, :only => [:set_status]
    before_filter :check_approve_reject, :only => [:approve, :reject]
    #may be better to prepopulate database so can do enroll.attendances instead of having to manually checking the existence of each week.....
    #but that is that more work? have to seed the database everytime someone creates an enroll, destroy taken care of

    #mentor_show.html.erb very awkward careuse when manually assigning status of attendance, might be creating one, or might be updating one, so code is very hacky, deal with post vs patch (can just force post tbh)
    #also, how to set to unexcused absence??? need to manually add option to delete lol, or add enum status anyway? that just sucks. or tell mentors to change to absent-denied?
    def mentor_index        
    end
    #need to secure all paths!
    def index
        @enrolls = current_user.enrolls
    end
    def approve
        a = Attendance.find(params[:id])
        a.excused!
        a.save
        redirect_to :back
    end

    def approve_all
        section = Section.find(params[:id])
        n = params[:week]
        students = section.enrolls
        students.each do |student|
          attendance = Attendance.where(enroll_id: student.id, week: n).take
          if attendance.nil?
            attendance = Attendance.new(enroll_id: student.id, week: n)
          end
          attendance.approved!
          attendance.save
        end
        redirect_to :back
    end

    def reject
        a = Attendance.find(params[:id])
        a.denied!
        a.save
        redirect_to :back
    end
    def set_status
        attendance = Attendance.where(enroll_id: params[:attendance][:enroll_id], week: params[:attendance][:week]).take
        if attendance.nil?
            Attendance.new(attendance_params).save!
        else
            attendance.update!(attendance_params)
        end
        redirect_to :back
    end
    #need to do something similar to check_enrollment in application_controller.rb to make sure only the actual student can meddle
    def show
        @enroll = Enroll.find(params[:id])
        @blank_attendance = Attendance.new
        @current_week = getCurrentWeek(@enroll.course)
    end
    def set_pass
        section = Section.find(params[:id])
        if section.update!(section_pass_params)
            flash[:notice] = "Updated"
        else
            flash[:notice] = "An error occurred"
        end
        redirect_to :back
    end
    def mentor_show
        enr = Jenroll.find(params[:id])
        @students = enr.section.enrolls
        @current_week = getCurrentWeek(enr.course)
        @section = enr.section
        @max_week = getMaxWeek
    end
    def mentor_show_senior
        enr = Senroll.find(params[:id])
        @students = enr.section.enrolls
        @current_week = getCurrentWeek(enr.course)
        @section = enr.section
        @max_week = getMaxWeek
        render "mentor_show"
    end
    #need to make sure the week doesn't already exist to ensure people don't try to fake it
    def create
        if Attendance.exists?(enroll_id: params[:attendance][:enroll_id], week: params[:attendance][:week])
            flash[:notice] = "An attendance record already exists for this week"
        else
            attendance = Attendance.new(attendance_params)
            attendance.pending!
            if attendance.save
                flash[:notice] = "Your absence request has been recorded, please check back to see its status"
            else
                flash[:notice] = "An error occurred, please try again."
            end
        end
        redirect_to student_attendance_path(params[:attendance][:enroll_id])
    end
    def checkin        
        if Attendance.exists?(enroll_id: params[:attendance][:enroll_id], week: params[:attendance][:week])
            flash[:notice] = "An attendance record already exists for this week"
        else
            sec = Enroll.find(params[:attendance][:enroll_id]).section
            if !sec.pass_enabled
                flash[:notice] = "Check ins for this section are currently disabled."
            elsif params[:attendance][:reason] == sec.password
                attendance = Attendance.new(attendance_params)
                attendance.approved!
                if attendance.save
                    flash[:notice] = "Check in successful!"
                else
                    flash[:notice] = "An error occurred, please try again."
                end
            else
                flash[:notice] = "Incorrect password."
            end
        end
        redirect_to student_attendance_path(params[:attendance][:enroll_id])
    end
    private
    def attendance_params
        params.require(:attendance).permit(:reason, :status, :week, :enroll_id)
    end
    private 
    def section_pass_params
        params.require(:section).permit(:password, :pass_enabled)
    end
    #need to save this globally so it doesn't look it up every time....
    private 
    def getBaseWeek(course)
        if course.base_week.nil?
            return DateTime.parse(Setting.find_by(name: "start_week").value)
        else
            return DateTime.parse(course.base_week)
        end
    end
    private
    private 
    def getCurrentWeek(course)
        return (DateTime.now - getBaseWeek(course)).to_i / 7 + 1
    end
    private 
    def getMaxWeek
        return Setting.find_by(name: "max_week").value.to_i
    end
    private 
    def check_student_access
        if !check_enrollment(Enroll.find(params[:id]))
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
    private 
    def check_student_create_access
        if !check_enrollment(Enroll.find(params[:attendance][:enroll_id]))
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
    private 
    def check_junior_mentor_access
        if !check_enrollment(Jenroll.find(params[:id]))
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
    private 
    def check_senior_mentor_access
        if !check_enrollment(Senroll.find(params[:id]))
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
    private 
    def check_mentor_section_access
        if !check_enrollment(Section.find(params[:id]).getMentor)
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path  
        end
    end
    private 
    def check_owns_student
        if !check_enrollment(Enroll.find(params[:attendance][:enroll_id]).section.getMentor)
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
    private 
    def check_approve_reject
        if !check_enrollment(Attendance.find(params[:id]).enroll.section.getMentor)
            flash[:notice] = "You do not have access to this page."
            redirect_to root_path
        end
    end
end
