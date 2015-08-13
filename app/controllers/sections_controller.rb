class SectionsController < ApplicationController
	def index
		@sections = Section.all
	end
	def show
		@section = Section.find(params[:id]);
	end
	def make_switch
		@old_section = Section.find(params[:old_id])
		@new_section = Section.find(params[:new_id])
		@enrollment = Enroll.find(params[:enroll_id])
		@enrollment.switchSection(@old_section, @new_section, current_user)
		flash[:notice] = "Successfully switched your section from " << @old_section.name << " to " << @new_section.name
		redirect_to "/"
	end
end
