class UsersController < ApplicationController
    before_filter :check_admin
    def destroy
        @user = User.find(params[:id])
        name = @user.name
        if @user.destroy
            flash[:notice] = "User " + name + " deleted."
            redirect_to students_index_path
        end 
    end
end
