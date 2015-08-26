class HomesController < ApplicationController
  before_filter :check_logged_in

  def index
  	@enrolls = current_user.enrolls
    @courses = Course.all
  end
end
