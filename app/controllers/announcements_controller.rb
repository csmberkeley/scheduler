class AnnouncementsController < ApplicationController
	before_filter :check_admin

	def edit
		@announcement = Announcement.all.first
	end

	def update
		@announcement = Announcement.all.first
    	@announcement.info = params[:announcement][:info]
    	flash[:notice] = "Announcement updated"
    	@announcement.save
    	redirect_to settings_path
	end
end
