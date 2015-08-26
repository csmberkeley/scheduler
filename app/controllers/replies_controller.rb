class RepliesController < ApplicationController
	def destroy
		@reply = Reply.find(params[:id])
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
		enrollment1 = reply.getEnrollmentOfReplier
		enrollment2 = offer.getEnrollmentOfOfferer
		enrollment1.tradeSection(enrollment2)
		if offer.destroy
			flash[:notice] = "Traded your section!"
			enrollment1.createTransaction("Your reply to an offer has been accepted!")
			enrollment2.createTransaction("You accepted a reply to an offer!")
			redirect_to "/"
		end
	end

	def deny
		reply = Reply.find(params[:id])
		offer = Offer.find(reply.offer_id)
		enrollment1 = reply.getEnrollmentOfReplier
		enrollment2 = offer.getEnrollmentOfOfferer
		if reply.destroy
			flash[:notice] = "Denied user"
			enrollment1.createTransaction("Your reply to an offer has been denied.")
			enrollment2.createTransaction("You denied a reply to an offer.")
			redirect_to offer_path(offer)
		end

	end
	private
	def reply_params
		params.require(:reply).permit(:body)
	end
end
