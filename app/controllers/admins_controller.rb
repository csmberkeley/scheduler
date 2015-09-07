class AdminsController < ApplicationController
  before_filter :check_admin
  def index
    @students = User.all
    @courses = Course.all
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
    begin
      student = params[:student].split(" ")
      student.pop
      user = User.find_by_name(student.join(" "))
      section = Section.find(params[:section])
      user.enrolls.each do |enroll|
        if enroll.course_id == section.course_id
          enroll.section_id = section.id
          enroll.save
          flash[:notice] = "Added student #{user.name} to #{section.name}"
          redirect_to manage_sections_path
          return
        else
          flash[:alert] = "Student not enrolled in the course. Select another student."
          redirect_to manage_sections_path
        end
      end
    rescue
      flash[:alert] = "Error in enrolling student."
      redirect_to manage_sections_path
    end
  end

  def drop_student_from_section
    enroll = Enroll.find(params[:id])
    student = User.find(enroll.user_id)
    section = Section.find(enroll.section_id)
    enroll.section_id = nil
    if enroll.save!
      flash[:notice] = "Dropped #{student.name} from #{section.name}"
      redirect_to manage_sections_path
    else
      flash[:alert] = "Could not drop #{student.name} from #{section.name}"
      redirect_to manage_sections_path
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
    Course.all.each do | course |
      @sections[course.course_name] = { "Monday" => [], "Tuesday" => [], "Wednesday" => [], 
        "Thursday" => [], "Friday" => [] }
      course.sections.each do | section |
        number = section.name.split.last.to_i
        day_of_the_week = number / 100 % 10
        case day_of_the_week
        when 0
          @sections[course.course_name]["Monday"] << section
        when 1
          @sections[course.course_name]["Tuesday"] << section
        when 2
          @sections[course.course_name]["Wednesday"] << section
        when 3
          @sections[course.course_name]["Thursday"] << section
        when 4
          @sections[course.course_name]["Friday"] << section
        else
          next
        end
      end
    end
  end
  def add_course
    @user = User.find(params[:user_id])
    @course = Course.find(params[:course].values[0][:name].to_i)
    Enroll.create(:user_id => params[:user_id], :course_id => params[:course].values[0][:name].to_i)
    flash[:notice] = "Added #{@user.name} to #{@course.course_name}" 
    redirect_to students_index_path
  end

  private

  def student_params
    params.require(:user).permit(:name, :nickname, :admin, :email)
  end

end
