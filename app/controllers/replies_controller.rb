class RepliesController < ApplicationController
	def create
		@reply = Reply.new(reply_params)
		@offer = Offer.find(eval(params[:offer_id])[:value])
		@offer.replies << @reply
		@reply.user_id = current_user.id
		@reply.offer_id = @offer.id
		@reply.status = "pending"
		@replies = @offer.getRepliesInOrder
		respond_to do |format|
		    if @offer.save && @reply.save
		      format.js
		    else
		      # format.html { render action: "new" }
		      # format.json { render json: @user.errors, status: :unprocessable_entity }
		    end
		end
	end
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
