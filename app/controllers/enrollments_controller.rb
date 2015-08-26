class EnrollmentsController < ApplicationController
	def switch_section
		@enrollment = Enroll.find(params[:id])
		@section = Section.find(@enrollment.section_id)
		@course = Course.find(@enrollment.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = @enrollment.getOffer
		@compatable_offers = Offer.getCompatableOffers(@section)
		@transactions = @enrollment.transactions
	end
end
