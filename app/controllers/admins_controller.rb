require 'will_paginate/array'

class AdminsController < ApplicationController
  before_filter :check_admin
  def index
    @students = Set.new
    Enroll.all.each do |enroll|
      @students.add(enroll.user)
    end

    if params[:filter_course]
      @courses = params[:filter_course].keys.map{ |course_id| Course.find(course_id) }
    elsif params[:filter_active]
      @courses = params[:filter_active].map{ |course_id| Course.find(course_id) }
    end

    @total_course_enrollment = 0
    Course.all.each do |course|
      @total_course_enrollment += course.enrolls.length
    end
    @total_section_enrollment = 0
    Section.all.each do |section|
      @total_section_enrollment += section.enrolls.length
    end

    @total_students = @students.length
    @students = @students.to_a.paginate(page: params[:page], per_page: 20)
  end

  def mentor_index
    @mentors = Set.new
    Jenroll.all.each do |enroll|
      @mentors.add(enroll.user)
    end
    Senroll.all.each do |enroll|
      @mentors.add(enroll.user)
    end
  end

  def new_student
    @student = User.new
  end

  def create_student
    @student = User.new(student_params)
    @student.confirmed_at = "2015-09-09 02:50:19"
    if @student.save!
       flash[:notice] = "Created user #{@student.name}!"
       redirect_to students_index_path
    end
  end

  def new_student_to_section
    # list out all students that can add this section
    # need to filter out students who aren't enrolled in this class
    # need to filter out students who are enrolled in the class but are enrolled in another section
    @section = Section.find(params[:id])
    course = Course.find(@section.course_id)
    enrolls = Enroll.where(:course_id => @section.course_id, :section_id => nil)
    @students = []
    enrolls.each do |enroll|
    user = User.find(enroll.user_id)
    if user
      @students << user.name + " " + user.email
    end
    end
  end

  def add_student_to_section
    # begin
      student = params[:student].split(" ")
      student.pop
      user = User.find_by_name(student.join(" "))
      section = Section.find(params[:section])
      user.enrolls.each do |enroll|
        if enroll.course_id == section.course_id
          enroll.section_id = section.id
          enroll.save
          flash[:notice] = "Added student #{user.name} to #{section.name}"
          if Setting.find_by(name: 'silent').value == "0"
            UserMailer.add_email(user, section).deliver
          end
          redirect_to manage_sections_path(enroll.course_id)
          return
        else
          next
        end
        flash[:alert] = "Student not enrolled in the course. Select another student."
        redirect_to manage_sections_path(section.course_id)
        return
      end
    # rescue => exception
    #  flash[:alert] = "Error in enrolling student." + exception.backtrace
    #  redirect_to manage_sections_path
    # end
      redirect_to manage_sections_path(section.course_id)
  end

  def drop_student_from_section
    enroll = Enroll.find(params[:id])
    student = User.find(enroll.user_id)
    section = Section.find(enroll.section_id)
    enroll.section_id = nil
    enroll.removeAllReplies
    if enroll.save!
      flash[:notice] = "Dropped #{student.name} from #{section.name}"
      if Setting.find_by(name: 'silent').value == "0"
        UserMailer.drop_email(student, section).deliver
      end
      redirect_to manage_sections_path(section.course_id)
    else
      flash[:alert] = "Could not drop #{student.name} from #{section.name}"
      redirect_to manage_sections_path(section.course_id)
    end
  end

  def edit_student
      @student = User.find(params[:id])
  end

  def update_student
      student = User.find(params[:id])
   #   student.update!(params[:user])
      flash[:notice] = "#{student.name} updated."
      student.update!(student_params)
      redirect_to students_index_path
  end

  def manage_sections
    # final product
    @sections = {}
    if params[:format]
      courses = Array.wrap(Course.find(params[:format]))
    else
      courses = Course.all.order(course_name: :asc) 
    end
    courses.each do | course |
      @sections[course.course_name] = { "Monday" => [], "Tuesday" => [], "Wednesday" => [], 
        "Thursday" => [], "Friday" => [] }
      course.sections.each do | section |
        @sections[course.course_name][section.getDay] << section
      end
      @sections[course.course_name]["Monday"].sort!{|a,b| a.start && b.start ? [a.start, a.name] <=> [b.start, b.name] : a.start ? -1 : 1 }
      @sections[course.course_name]["Tuesday"].sort!{|a,b| a.start && b.start ? [a.start, a.name] <=> [b.start, b.name] : a.start ? -1 : 1 }
      @sections[course.course_name]["Wednesday"].sort!{|a,b| a.start && b.start ? [a.start, a.name] <=> [b.start, b.name] : a.start ? -1 : 1 }
      @sections[course.course_name]["Thursday"].sort!{|a,b| a.start && b.start ? [a.start, a.name] <=> [b.start, b.name] : a.start ? -1 : 1 }
      @sections[course.course_name]["Friday"].sort!{|a,b| a.start && b.start ? [a.start, a.name] <=> [b.start, b.name] : a.start ? -1 : 1 }
    end
  end

  def manage_attendance
    @mentors = Set.new
    Jenroll.all.each do |enroll|
      @mentors.add(enroll.user)
    end
    Senroll.all.each do |enroll|
      @mentors.add(enroll.user)
    end
    @students = Set.new
    Enroll.all.each do |enroll|
      @students.add(enroll.user)
    end
    @sections = Set.new
    Section.all.each do |section|
      @sections.add(section)
    end
  end

  def add_course
    @user = User.find(params[:user_id])
    @course = Course.find(params[:course].values[0][:name].to_i)
    Enroll.create(:user_id => params[:user_id], :course_id => params[:course].values[0][:name].to_i)
    flash[:notice] = "Added #{@user.name} to #{@course.course_name}" 
    redirect_to students_index_path
  end

  def send_email
    Section.all.each do |section|
      UserMailer.section_email(section).deliver
      UserMailer.mentor_email(section).deliver
    end
    flash[:notice] = "emails sent"
    redirect_to root_path
  end
  private

  def student_params
    params.require(:user).permit(:name, :nickname, :admin, :email, :password)
  end

end
