class CommentsController < ApplicationController
	before_filter :check_destroy, :only => [:destroy]
	before_filter :check_logged_in
	def destroy
		@comment = Comment.find(params[:id])
		@enroll = @comment.getEnrollmentOfCommenter
		@offer = Offer.find(@comment.offer_id)
		@comments = @offer.getCommentsInReverseOrder
		respond_to do |format|
		    if @comment.destroy
		      format.js
		    else
		      # format.html { render action: "new" }
		      # format.json { render json: @user.errors, status: :unprocessable_entity }
		    end
		end
	end
	def error
		respond_to do |format|
		    format.js
		end
	end

  #before_filters
  private
  def check_destroy
  	@notice = "You do not have permission to do that."
  	if params[:id] and Comment.exists?(params[:id])
  		comment = Comment.find(params[:id])
  		if check_enrollment(enroll = comment.getEnrollmentOfCommenter)
  			if enroll.user_id == comment.user_id
  				return
  			end
  		end
  	else
  		@notice = "This comment has already been deleted."
  	end
  	flash[:notice] = notice
  	render "error"
  end
end
