class OffersController < ApplicationController
	before_filter :check_comment, :only => [:create_response]
	def show
		@offer = Offer.find(params[:id])
		@offerer = User.find(@offer.user_id)
		@section = Section.find(@offer.section_id)
		@course = Course.find(@section.course_id)
		@enroll = current_user.getEnrollmentInCourse(@course)
		@wanted_sections = @offer.getWantedSections
		@comments = @offer.comments.order(:created_at).reverse_order
		@new_comment = Comment.new
		@replies = @offer.replies.order(:created_at)
		@new_reply = Reply.new
		@comments_allowed = Setting.find_by(name: 'comments').enabled
	end
	def new
		#needs to check whether or not user has an offer
		@enrollment = Enroll.find(params[:enroll_id])
		@section = Section.find(@enrollment.section_id)
		@other_sections = @section.getAllOtherSections
		@new_offer = Offer.new(:section_id => @section.id, :user_id => current_user.id, :enroll_id => @enrollment.id)
	end
	def create
		#@enroll is enrollment
		@offer = Offer.new(offer_params)
		@enroll = @offer.getEnrollmentOfOfferer
		@offerer = User.find(@enroll.user_id)
		@offerer_section = Section.find(@enroll.section_id)
		@offerer.offers << @offer
		@offerer_section.offers << @offer
		if @offer.save
			section_ids = params[:section_ids]
			@offer.createWants(section_ids)
			flash[:notice] = "Created an offer for your section!"
			@offered_section = Section.find(@offer.section_id)
			@offer.getEnrollmentOfOfferer.createTransaction("You created an offer for " << @offered_section.name)
			redirect_to offer_path(@offer)
		end
	end
	def destroy
		@enroll = Enroll.find(params[:id])
		@offer = @enroll.offer
		if @offer
			if @offer.destroy
				flash[:notice] = "Canceled your offer for your section."
				@enroll.createTransaction("You canceled your offer for " << Section.find(@offer.section_id).name)
			else
				flash[:notice] = "Something went wrong with deleting your offer. Try again later."
			end
		else
			flash[:notice] = "You don't have an offer to cancel."
		end
		redirect_to "/"
	end

	def create_response
		#needs to check if params[:switch] is there
		@body = params[:body]
		@offer = Offer.find(eval(params[:offer_id])[:value])
		@enroll = Enroll.find(eval(params[:enroll_id])[:value])
		if params[:switch]
			@reply = Reply.new(body: @body)
			@offer.replies << @reply
			@reply.user_id = current_user.id
			@reply.offer_id = @offer.id
			@replies = @offer.getRepliesInOrder
			@comments = @offer.getCommentsInReverseOrder
			respond_to do |format|
			    if @offer.save && @reply.save
			    	@reply.getEnrollmentOfReplier.createTransaction("You created a reply to an offer.")
			      format.js
			    else
			      # format.html { render action: "new" }
			      # format.json { render json: @user.errors, status: :unprocessable_entity }
			    end
			end
		else
			@comment = Comment.new(body: @body)
			@offer.comments << @comment
			@comment.user_id = current_user.id
			@comment.offer_id = @offer.id
			@replies = @offer.getRepliesInOrder
			@comments = @offer.getCommentsInReverseOrder
			respond_to do |format|
			    if @offer.save && @comment.save
			    	@comment.getEnrollmentOfCommenter.createTransaction("You created a comment to an offer.")
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
		params.require(:offer).permit(:body, :enroll_id)
	end
end
