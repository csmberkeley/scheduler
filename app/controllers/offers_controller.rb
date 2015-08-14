class OffersController < ApplicationController
	def show
		@offer = Offer.find(params[:id])
		@comments = @offer.comments.order(:created_at).reverse_order
		@new_comment = Comment.new
	end
	def new
		@my_section = Section.find(params[:section_id])
		@other_sections = @my_section.getAllOtherSections
		@new_offer = Offer.new(:section_id => @my_section.id, :user_id => current_user.id, :status => "pending")
	end
	def create
		@offer = Offer.new(offer_params)
		if @offer.save
			params[:section_ids].each do |id|
				curr_want = Want.create(offer_id: @offer.id, section_id: id)
			end
			flash[:notice] = "Created an offer for your section!"
			redirect_to "/"
		end
	end

	private
	def offer_params
		params.require(:offer).permit(:body, :section_id, :user_id, :status)
	end
end
