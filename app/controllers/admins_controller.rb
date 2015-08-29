class AdminsController < ApplicationController
    before_filter :check_admin
    def index
        @students = User.all
        
    end
end
