class HomesController < ApplicationController
  before_filter :check_logged_in

  def index
  	@enrolls = current_user.enrolls
  	@senrolls = current_user.senrolls
  	@jenrolls = current_user.jenrolls
  	@classes_to_jenrolls = Hash.new([])
  	@classes_to_senrolls = Hash.new([])
  	@jenrolls.each do |jenroll|
  		curr_class_name = Course.find(jenroll.course_id).course_name
  		@classes_to_jenrolls[curr_class_name] = @classes_to_jenrolls[curr_class_name] + [jenroll]
  	end
  	@senrolls.each do |senroll|
  		curr_class_name = Course.find(senroll.course_id).course_name
  		@classes_to_senrolls[curr_class_name] = @classes_to_senrolls[curr_class_name] + [senroll]
  	end
    @show_tabs = (@enrolls.size > 0 and (@jenrolls.size + @senrolls.size) > 0)
  end
end
