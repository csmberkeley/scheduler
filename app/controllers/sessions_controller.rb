class SessionsController < ApplicationController
	def new
		@topic = Topic.find(params[:topic_id])
		@session = Session.new
	end

	def create
		@session = Session.new(session_params)
		@session.tutee_id = current_user.id
		#TODO: add session to topic and vice versa
		if @session.save
			#save stuff
			redirect_to "/sessions"
		else
			render 'new'
		end
	end

	def index
		@sessions = Session.where(tutee_id: current_user.id)
	end

	private
	def session_params
		puts "HELLO"
		puts params
		puts "1 THING"
		puts params[:session][:availability]
		puts "2 THING"
		puts params[:session][:additional_info]

		params.require(:session).permit(:availability, :additional_info)
	end
end