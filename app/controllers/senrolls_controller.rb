class SenrollsController < ApplicationController
	def destroy
    	@senroll = Senroll.find(params[:id])
    	@senroll.destroy
    	flash[:notice] = "You are no longer mentoring that section."
    	redirect_to root_path
    end

    def edit
  #   	@senroll = Senroll.find(params[:id])
  #   	@course = Course.find(@senroll.course_id)
		# @sections = Section.getSectionsWithoutMentor(@course)
    end
    def update
    	# @senroll = Senroll.find(params[:id])
    	# if @senroll.update_attributes(senroll_params)
    	# 	flash[:notice] = "Switched the section you're mentoring for."
    	# 	redirect_to root_path
    	# else
    	# 	flash[:notice] = "Something went wrong. Please try again later."
    	# 	redirect_to root_path
    	# end
    end

    def switch
    	@senroll = Senroll.find(params[:id])
    	@course = Course.find(@senroll.course_id)
		@sections = Section.getSectionsWithoutMentor(@course)
    end

    def update_switch
    	@senroll = Senroll.find(params[:id])
    	if @senroll.update_attributes(senroll_params)
    		flash[:notice] = "Switched the section you're mentoring for."
    		redirect_to root_path
    	else
    		flash[:notice] = "Something went wrong. Please try again later."
    		redirect_to root_path
    	end
    end

    def roster
    	@senroll = Senroll.find(params[:id])
    	@students = @senroll.getStudents()
        @email_list = ""
        @students.each_with_index do |student, i| 
            if i == 0
                @email_list << student.email
            else
                @email_list << ", #{student.email}"
            end
        end
        render "jenrolls/roster"
    end

    private
	def senroll_params
		params.require(:senroll).permit(:section_id)
	end
end
