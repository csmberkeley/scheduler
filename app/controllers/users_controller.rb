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
    def contract
        @user = User.find(params[:id])
    end
    def sign_contract
        @user = User.find(params[:id])
        @user.mentor_verified = true
        @user.save
        flash[:notice] = "Thanks for signing!"
        redirect_to new_jenroll_path
    end
end
