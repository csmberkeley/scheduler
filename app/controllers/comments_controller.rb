class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@offer = Offer.find(eval(params[:offer_id])[:value])
		@offer.comments << @comment
		@comment.user_id = current_user.id
		@comment.offer_id = @offer.id
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
	def destroy
		@comment = Comment.find(params[:id])
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

	def index
		# @comments = Comment.where(tutee_id: current_user.id)
	end

	private
	def comment_params
		params.require(:comment).permit(:body)
	end
end
