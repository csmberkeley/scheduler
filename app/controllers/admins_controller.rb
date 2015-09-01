class AdminsController < ApplicationController
  before_filter :check_admin
  def index
    @students = User.all

    @courses = Course.all
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
