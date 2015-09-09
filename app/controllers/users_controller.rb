class UsersController < ApplicationController
    before_filter :check_admin
    def destroy
        @user = User.find(params[:id])
        name = @user.name
        if @user.destroy
            if name
            flash[:notice] = "User " + name + " deleted."
            else
             flash[:notice] = "User deleted."
            end
            redirect_to students_index_path
        end 
    end
end
