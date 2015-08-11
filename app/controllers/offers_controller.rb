class OffersController < ApplicationController
	def show
		@offer = Offer.find(params[:id])
		@comments = @offer.comments.order(:created_at).reverse_order
		@new_comment = Comment.new
	end
end
