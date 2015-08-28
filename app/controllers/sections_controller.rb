class SectionsController < ApplicationController
	before_filter :check_switch, :only => [:make_switch]
	def index
		@sections = Section.all
	end

	def show
		@section = Section.find(params[:id]);
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
		redirect_to "/"
	end
end
