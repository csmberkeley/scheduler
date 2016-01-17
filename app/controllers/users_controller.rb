class UsersController < ApplicationController
    before_filter :check_logged_in
    before_filter :check_admin, :only => [:destroy]
    before_filter :check_user, :only => [:contract, :sign_contract]
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
        if @user.mentor_verified
            flash[:notice] = "You already signed our contract!"
            redirect_to root_path
        end
    end
    def sign_contract
        @user = User.find(params[:id])
        @user.mentor_verified = true
        @user.save
        flash[:notice] = "Thanks for signing!"
        redirect_to new_jenroll_path
    end

    private 
    def check_user
        if params[:id] and User.exists?(params[:id])
            user = User.find(params[:id])
            if current_user.id == user.id
                return
            end
        end
        flash[:notice] = "You do not have permission to view this page."
        redirect_to root_path
    end
end
