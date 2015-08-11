class SectionsController < ApplicationController
	def index
		@sections = Section.all
	end
	def show
		@section = Section.find(params[:id]);
	end
	def switch
		@section = Section.find(params[:id])
		@offers = current_user.offers.where(section_id: @section.id)
	end
end
