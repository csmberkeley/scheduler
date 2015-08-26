class SettingsController < ApplicationController
    def index
        @settings = Setting.all

    end
    def update
        #Setting.find(params[:name]).toggle = params[:name]
        Setting.update(params[:setting].keys, params[:setting].values)
        redirect_to settings_path
        flash[:notice] = "Settings updated!"
    end
end
