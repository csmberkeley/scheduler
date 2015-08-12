class SectionsController < ApplicationController
	def index
		@sections = Section.all
	end
	def show
		@section = Section.find(params[:id]);
	end
	def switch
		@section = Section.find(params[:id])
		@course = Course.find(@section.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = Offer.getUserOfferFromSection(current_user, @section)
	end
end
