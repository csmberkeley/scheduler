class OffersController < ApplicationController
	def show
		@offer = Offer.find(params[:id])
		@offer_user = User.find(@offer.user_id)
		@section = Section.find(@offer.section_id)
		@wanted_sections = []
		@offer.wants.each do |want|
			@wanted_sections << Section.find(want.section_id)
		end
		@comments = @offer.comments.order(:created_at).reverse_order
		@new_comment = Comment.new
		@replies = @offer.replies.order(:created_at)
		@new_reply = Reply.new
	end
	def new
		@my_section = Section.find(params[:section_id])
		@other_sections = @my_section.getAllOtherSections
		@new_offer = Offer.new(:section_id => @my_section.id, :user_id => current_user.id, :accepted => false)
	end
	def create
		@offer = Offer.new(offer_params)
		if @offer.save
			params[:section_ids].each do |id|
				curr_want = Want.create(offer_id: @offer.id, section_id: id)
			end
			flash[:notice] = "Created an offer for your section!"
			redirect_to offer_path(@offer)
		end
	end
	def destroy
		@enroll = Enroll.find(params[:id])
		@section = Section.find(@enroll.section_id)
		@offer = Offer.getUserOfferFromSection(current_user, @section)
		if @offer
			if @offer.destroy
				flash[:notice] = "Canceled your offer for your section."
			else
				flash[:notice] = "Something went wrong with deleting your offer. Try again later."
			end
		else
			flash[:notice] = "You don't have an offer to cancel."
		end
		redirect_to "/"
	end

	def create_response
		if params[:switch]
			@reply = Reply.new(body: params[:body])
			@offer = Offer.find(eval(params[:offer_id])[:value])
			@offer.replies << @reply
			@reply.user_id = current_user.id
			@reply.offer_id = @offer.id
			@reply.status = "pending"
			@replies = @offer.getRepliesInOrder
			@comments = @offer.getCommentsInReverseOrder
			respond_to do |format|
			    if @offer.save && @reply.save
			      format.js
			    else
			      # format.html { render action: "new" }
			      # format.json { render json: @user.errors, status: :unprocessable_entity }
			    end
			end
		else
			@comment = Comment.new(body: params[:body])
			@offer = Offer.find(eval(params[:offer_id])[:value])
			@offer.comments << @comment
			@comment.user_id = current_user.id
			@comment.offer_id = @offer.id
			@replies = @offer.getRepliesInOrder
			@comments = @offer.getCommentsInReverseOrder
			respond_to do |format|
			    if @offer.save && @comment.save
			      format.js
			    else
			      # format.html { render action: "new" }
			      # format.json { render json: @user.errors, status: :unprocessable_entity }
			    end
			end
		end
	end

	private
	def offer_params
		params.require(:offer).permit(:body, :section_id, :user_id, :status)
	end
end
