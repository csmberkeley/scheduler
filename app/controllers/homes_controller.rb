class HomesController < ApplicationController
  before_filter :check_logged_in

  def index
  	@enrolls = current_user.enrolls
  	@senrolls = current_user.senrolls
  	@jenrolls = current_user.jenrolls
  	@courses_to_mentor_enrolls = Hash.new([])
  	@jenrolls.each do |jenroll|
  		curr_class_name = Course.find(jenroll.course_id).course_name
  		@courses_to_mentor_enrolls[curr_class_name] = @courses_to_mentor_enrolls[curr_class_name] + [jenroll]
  	end
  	@senrolls.each do |senroll|
  		curr_class_name = Course.find(senroll.course_id).course_name
  		@courses_to_mentor_enrolls[curr_class_name] = @courses_to_mentor_enrolls[curr_class_name] + [senroll]
  	end
    @show_tabs = (@enrolls.size > 0 and (@jenrolls.size + @senrolls.size) > 0)
    if Setting.find_by(name: 'announcement').value == "1"
      @announcement = Announcement.all.first
    end
  end
end
