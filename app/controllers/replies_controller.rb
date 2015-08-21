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

	private
	def reply_params
		params.require(:reply).permit(:body)
	end
end
