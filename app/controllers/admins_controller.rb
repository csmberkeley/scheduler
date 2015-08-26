class AdminsController < ApplicationController
    def index
        @students = User.all
        
    end
end
