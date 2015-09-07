class CoursesController < ApplicationController
	before_filter :check_logged_in
	before_filter :check_admin, :except => [:index, :show]
	def index
		@courses = Course.all
	end
	def admin_index
		@courses = Course.all
	end
	def show
		@course = Course.find(params[:id])
		@number_of_people = @course.enrolls.length
	end
	def new
		@course = Course.new
	end
	def create
		@course = Course.create(course_params)
		flash[:notice] = "#{@course.course_name} created!"
		redirect_to admin_course_index_path
	end
	def edit
		@course = Course.find(params[:id])
	end
	def update
		@course = Course.find(params[:id])
		@course.update(course_params)
		flash[:notice] = "#{@course.course_name} successfully updated!"
		redirect_to admin_course_index_path
	end
	def destroy
		@course = Course.find(params[:id])
		@course.enrolls.each do |e|
			e.removeAllReplies
		end
		if @course.destroy
			flash[:notice] = "#{@course.course_name} successfully deleted."
		else
			flash[:alert] = "Something went wrong."
		end
		redirect_to admin_course_index_path
	end
	private
	def course_params
      params.require(:course).permit(:course_name, :semester, :year, :password, :instructor, :description)
    end
end
