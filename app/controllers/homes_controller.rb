class HomesController < ApplicationController
  before_filter :check_logged_in

  def index
  	@enrolls = current_user.enrolls
  	@senrolls = current_user.senrolls
  	@jenrolls = current_user.jenrolls
  end
end
