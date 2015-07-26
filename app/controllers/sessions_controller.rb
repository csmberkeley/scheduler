class SessionsController < ApplicationController
	def new
		@topics = []
		@courses.each do |c|
			@topics += c.topics
		end
	end

	def create
	end
end
