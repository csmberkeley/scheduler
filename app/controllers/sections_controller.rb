class SectionsController < ApplicationController
	before_filter :check_logged_in
	before_filter :check_make_switch, :only => [:make_switch]
	before_filter :check_admin, :only => [:new, :create, :edit, :update, :destroy]
	before_filter :check_drop, :only => [:drop]
	def index
		@sections = {}
		course_ids = Set.new
		current_user.enrolls.each do |enroll|
			course_ids.add(enroll.course_id)
		end
		current_user.jenrolls.each do |jenroll|
			course_ids.add(jenroll.course_id)
		end
		current_user.senrolls.each do |senroll|
			course_ids.add(senroll.course_id)
		end
		@courses = []
		course_ids.each do |course_id|
			@courses << Course.find(course_id)
		end
		@courses.sort! {|course1, course2| course1.course_name <=> course2.course_name}
	  	@courses.each do | course |
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

	def show
		@section = Section.find(params[:id]);
		@section_limit = @section.getLimit()
	end

	def load_course_names
    names = []
    Course.all.each do |course|
      names << course.course_name
    end
    return names
  end

	def new
		@section = Section.new
		@courses = load_course_names
	end

	def create
		course = Course.find_by_course_name(params[:section][:course_id])
		params[:section][:course_id] = course.id
		section = Section.new(section_params)
		if section.save
			flash[:notice] = "Made #{section.name}"
			redirect_to manage_sections_path(course)
		else
			render :action => 'new'
		end
	end

	def edit
		@section = Section.find(params[:id])
		@courses = load_course_names
		@e_course = Course.find(@section.course_id)
	end

	def update
		section = Section.find(params[:id])
		course = Course.find_by_course_name(params[:section][:course_id])
		params[:section][:course_id] = course.id
		if section.update_attributes(section_params)
			flash[:notice] = "Edited #{section.name}"
      redirect_to manage_sections_path(course)
		else
			render :action => 'edit'
		end

	end

	def destroy
		section = Section.find(params[:id])
    course_id = section.course_id
		section.enrolls do |e|
			e.removeAllReplies
		end
		flash[:notice] = "Deleted #{section.name}"
		section.destroy
		redirect_to manage_sections_path(course_id)
	end

	def drop
		@enroll = Enroll.find(params[:enroll_id])
		@section = Section.find(@enroll.section_id)
		@enroll.removeAllReplies
		@section.enrolls.delete(@enroll)
		flash[:notice] = "You have successfully dropped " << @section.name
		redirect_to root_path
	end
	
	def make_switch
		#should not need old section
		#needs to check if new section is full
		@old_section = Section.find(params[:old_id])
		@new_section = Section.find(params[:new_id])
		@enrollment = Enroll.find(params[:enroll_id])
		if @enrollment.switchSection(@new_section)
			flash[:notice] = "Successfully switched your section from " << @old_section.name << " to " << @new_section.name
			@enrollment.createTransaction("You switched into section " << @new_section.name)
		else
			flash[:notice] = "Sorry, that section has been filled up."
		end
		redirect_to root_path
	end

	private
	def check_make_switch
		notice = "Cannot make the switch at this time."
		if params[:old_id] and Section.exists?(params[:old_id]) and params[:new_id] and Section.exists?(params[:new_id])
			if Setting.find_by(name: 'section').value == "1"
	       		if params[:enroll_id] and Enroll.exists?(params[:enroll_id]) and check_enrollment(enroll = Enroll.find(params[:enroll_id]))
	       			return
	       		end
	    	else
	    		notice = "Section switching has been disabled"
	    	end
		end
		flash[:alert] = notice
		redirect_to root_path
		
	end

	private
	def check_drop
		notice = "You do not have permission to access that page."
		if params[:enroll_id] and Enroll.exists?(params[:enroll_id]) and check_enrollment(enroll = Enroll.find(params[:enroll_id]))
			if enroll.section_id and Section.exists?(enroll.section_id)
				return
			else
				notice = "You do not have a section to drop."
			end
		end
		flash[:alert] = notice
		redirect_to root_path
	end

	private
	def section_params
		params.require(:section).permit(:name, :start, :end, :empty, :course_id, :location, :date, :limit)
	end
end
