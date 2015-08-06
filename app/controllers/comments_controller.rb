class CommentsController < ApplicationController
	def create
		@comment = Comment.new(comment_params)
		@section = Section.find(eval(params[:section_id])[:value])
		@section.comments << @comment
		@comment.from_id = current_user.id
		if @section.save && @comment.save
			redirect_to section_path(@section)
		else
			redirect_to section_path(@section)
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
