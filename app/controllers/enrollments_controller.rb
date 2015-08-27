class EnrollmentsController < ApplicationController
	def switch_section
		#enrollment works here
		@enrollment = Enroll.find(params[:id])
		@section = Section.find(@enrollment.section_id)
		@course = Course.find(@enrollment.course_id)
		@open_sections = @section.getOtherOpenSections()
		@offer = @enrollment.offer
		@compatable_offers = Offer.getCompatableOffers(@section)
		@transactions = @enrollment.getTransactionsInReverseOrder
	end
end
