class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@section = Section.find(eval(params[:section_id])[:value])
		@section.comments << @comment
		@comment.from_id = current_user.id
		respond_to do |format|
		    if @section.save && @comment.save
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
