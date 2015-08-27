class CommentsController < ApplicationController
	def destroy
		#needs enrollment
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
end
