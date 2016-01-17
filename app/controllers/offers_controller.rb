class OffersController < ApplicationController
	before_filter :check_logged_in
	before_filter :check_create_response, :only => [:create_response]
	before_filter :check_show, :only => [:show]
	before_filter :check_new, :only => [:new]
	before_filter :check_create, :only => [:create]
	before_filter :check_destroy, :only => [:destroy]
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
		@comments_allowed = Setting.find_by(name: 'comments').value == "1"
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
		redirect_to switch_section_path(@enroll)
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
	def error
		respond_to do |format|
		    format.js
		end
	end

	private
	def offer_params
		params.require(:offer).permit(:body, :enroll_id)
	end

	#**************************************************************************
  #before_filters
  private
  def check_show
  	#check if offer exists
  	notice = "The offer you are trying to view may have closed or does not exist."
  	correct_offer = false
  	if params[:id] and Offer.exists?(params[:id])
  		correct_offer = true
  	end
  	if correct_offer
  		notice = "You are not allowed access to that page."
  		#check if he is enrolled in the correct course
  		offer = Offer.find(params[:id])
		offerer = User.find(offer.user_id)
		section = Section.find(offer.section_id)
		course = Course.find(section.course_id)
		enroll = current_user.getEnrollmentInCourse(course)
		if check_enrollment(enroll) or current_user.admin
			return
		end
  	end
    flash[:notice] = notice
    redirect_to root_path
  end

  private
  def check_new
  	notice = "You are not allowed access to that page."
  	if params[:enroll_id] and Enroll.exists?(params[:enroll_id]) and check_enrollment(enroll = Enroll.find(params[:enroll_id]))
  		if enroll.hasSection
  			puts enroll.offer
  			if not enroll.offer
  				return
  			else 
  				notice = "You already have an offer."
  			end
  		end
  	end
  	flash[:notice] = notice
    redirect_to root_path
  end
  private
  def check_new
  	notice = "You are not allowed access to that page."
  	if params[:enroll_id] and Enroll.exists?(params[:enroll_id]) and check_enrollment(enroll = Enroll.find(params[:enroll_id]))
  		if enroll.hasSection
  			if not enroll.offer
  				return
  			else 
  				notice = "You already have an offer."
  			end
  		end
  	end
  	flash[:notice] = notice
    redirect_to root_path
  end
  private
  def check_create
  	notice = "You are not allowed to access that page."
  	path = root_path
  	if section_ids = params[:offer] and offer = Offer.new(offer_params)
  		if offer.enroll_id and check_enrollment(enroll = offer.getEnrollmentOfOfferer)
  			if params[:section_ids]
  				if not enroll.offer
	  				return
	  			end
  				notice = "You already have an offer."
  				path = offer_path(enroll.offer)
  			else
	  			notice = "You need to choose a section you want in your offer."
	  			path = new_offer_path(enroll_id: enroll.id)
  			end
  				
  		end
  	end
  	flash[:notice] = notice
  	redirect_to path
  end
  private
  def check_destroy
  	if not(params[:id] and Enroll.exists?(params[:id]) and check_enrollment(Enroll.find(params[:id])))
  		flash[:notice] = "You are not allowed to access that page."
  		redirect_to root_path
  	end
  end

  private
  def check_create_response
  	@notice = "You cannot create a comment."
  	if params[:offer_id] and params[:enroll_id]
  		if Offer.exists?(eval(params[:offer_id])[:value]) and Enroll.exists?(eval(params[:enroll_id])[:value])
  			offer = Offer.find(eval(params[:offer_id])[:value])
  			enroll = Enroll.find(eval(params[:enroll_id])[:value])
  			if check_enrollment(enroll)
  				if params[:switch]
  					if offer.hasReplyFrom(enroll)
  						@notice = "You have already made a reply to this offer."
  					else
  						if params[:body] == ""
  							@notice = "You cannot create a blank reply."
  						else
  							return
  						end	
  					end
  				else
  					if params[:body] == ""
						@notice = "You cannot create a blank comment."
					else 
						return
					end		
  				end
  			end
  		end
  	end
  	render "error"
  end

end
