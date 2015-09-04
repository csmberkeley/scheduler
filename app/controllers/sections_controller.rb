class SectionsController < ApplicationController
	before_filter :check_make_switch, :only => [:make_switch]
	before_filter :check_admin, :only => [:new, :create, :edit, :update, :destroy]
	before_filter :check_drop, :only => [:drop]
	def index
		@sections = Section.all
	end

	def show
		@section = Section.find(params[:id]);
	end

	def new
		@section = Section.new
	end

	def create
		@section = Section.new
	end

	def edit
		@section = Section.find(params[:id])
	end

	def update
		@section = Section.find(params[:id])
	end

	def destroy
		@section = Section.find(params[:id])
	end

	def drop
		@enroll = Enroll.find(params[:enroll_id])
		@section = Section.find(@enroll.section_id)
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
			if Setting.find_by(name: 'section').enabled
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
end
