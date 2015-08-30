class AdminsController < ApplicationController
    before_filter :check_admin
    def index
        @students = User.all    
    end
    def edit_student
        @student = User.find(params[:id])
    end
    def update_student
        student = User.find(params[:id])
     #   student.update!(params[:user])
        flash[:notice] = "#{student.name} updated."
        student.update!(student_params)
        redirect_to students_index_path
    end
    private
    def student_params
        params.require(:user).permit(:name, :nickname, :admin, :email)
    end
end
