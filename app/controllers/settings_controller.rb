class SettingsController < ApplicationController
    before_filter :check_logged_in, :check_admin
    def index
        @settings = Setting.all
        @announcement = Announcement.all.first
    end
    def update
        Setting.update(params[:setting].keys, params[:setting].values)
        redirect_to settings_path
        flash[:notice] = "Settings updated!"
    end
end
