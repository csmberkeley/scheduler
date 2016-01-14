class RepliesController < ApplicationController
	before_filter :check_respond, :only => [:accept, :deny]
	before_filter :check_destroy, :only => [:destroy]
	def destroy
		@reply = Reply.find(params[:id])
		@enroll = @reply.getEnrollmentOfReplier
		@offer = Offer.find(@reply.offer_id)
		@replies = @offer.getRepliesInOrder
		respond_to do |format|
		    if @reply.destroy
		      format.js
		    else
		      # format.html { render action: "new" }
		      # format.json { render json: @user.errors, status: :unprocessable_entity }
		    end
		end
	end
	def accept
		reply = Reply.find(params[:id])
		offer = Offer.find(reply.offer_id)
		replier_enrollment = reply.getEnrollmentOfReplier
		offerer_enrollment = offer.getEnrollmentOfOfferer
		replier_enrollment.tradeSection(offerer_enrollment)
		if offer.destroy
			flash[:notice] = "Traded your section!"
			replier_enrollment.createTransaction("Your reply to an offer has been accepted!")
			offerer_enrollment.createTransaction("You accepted a reply to an offer!")
			redirect_to root_path
		end
	end

	def deny
		reply = Reply.find(params[:id])
		offer = Offer.find(reply.offer_id)
		replier_enrollment = reply.getEnrollmentOfReplier
		offerer_enrollment = offer.getEnrollmentOfOfferer
		if reply.destroy
			flash[:notice] = "Denied user"
			replier_enrollment.createTransaction("Your reply to an offer has been denied.")
			offerer_enrollment.createTransaction("You denied a reply to an offer.")
			redirect_to offer_path(offer)
		end

	end
	def error
		respond_to do |format|
		    format.js
		end
	end
	private
	def reply_params
		params.require(:reply).permit(:body)
	end
	private
	def check_respond
		if params[:id] and Reply.exists?(params[:id])
			reply = Reply.find(params[:id])
			offer = Offer.find(reply.offer_id)
			if replier_enrollment = reply.getEnrollmentOfReplier and offerer_enrollment = offer.getEnrollmentOfOfferer
				if replier_enrollment.course_id == offerer_enrollment.course_id
					return
				end
			end
		end
		flash[:notice] = "You cannot trade."
		redirect_to root_path
	end
	
  #before_filters
  private
  def check_destroy
  	@notice = "You do not have permission to do that."
  	if params[:id] and Reply.exists?(params[:id])
  		reply = Reply.find(params[:id])
  		if check_enrollment(enroll = reply.getEnrollmentOfReplier)
  			if enroll.user_id == reply.user_id
  				return
  			end
  		end
  	else
  		@notice = "This reply has already been deleted."
  	end
  	flash[:notice] = notice
  	render "error"
  end


end
