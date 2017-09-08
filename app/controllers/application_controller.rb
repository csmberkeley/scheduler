class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_devise_params, if: :devise_controller?
  before_filter :update_associated_sections
  def configure_devise_params
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:name, :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:name, :email, :password, :password_confirmation, :current_password)
    end
  end

  private
  def check_admin
    if not user_signed_in? or not current_user.admin?
      flash[:alert] = "You do not have permission for this action"
      redirect_to root_path
    end
  end

  private
  def check_logged_in
    if not user_signed_in?
      flash[:alert] = "Sign in to continue"
      redirect_to new_user_session_path
    end
  end
  private
  def check_comment
    if not Setting.find_by(name: 'comments').value == "1"
        flash[:alert] = "Commenting has been disabled"
        redirect_to root_path
    end
  end
  private
  def check_enrollment(enrollment)
    if (current_user and enrollment and enrollment.user_id == current_user.id) or current_user.admin?
      return true
    end
    return false
  end

  private
  def update_associated_sections
    if user_signed_in?
      sections = []
      #student sections
      current_user.enrolls.each do |enroll|
        if enroll.section_id
          section = Section.find(enroll.section_id)
          sections << section
        end
      end
      #jm sections
      current_user.jenrolls.each do |enroll|
        if enroll.section_id
          section = Section.find(enroll.section_id)
          sections << section
        end
      end
      #sm sections
      current_user.senrolls.each do |enroll|
        if enroll.section_id
          section = Section.find_by(id:enroll.section_id)
          if section != nil 
            sections << section
          end
        end
      end
      #update sections
      weekly_change_time = Time.now.beginning_of_week
      sections.each do |section|
        if section.temp_end != nil or section.location != nil

          #comparing section temporary end time to current time
          days = {"Sunday" => 0, "Monday" => 1, "Tuesday" => 2, "Wednesday" => 3, "Thursday" => 4, "Friday" => 5, "Saturday" => 6}
          advance_hash = {}
          if section.temp_end != nil
            advance_hash[:days] = days[section.temp_date] - 1
            advance_hash[:minutes] = section.temp_end.min
            advance_hash[:hours] = section.temp_end.hour
          else
            advance_hash[:days] = days[section.date] - 1
            advance_hash[:minutes] = section.end.min
            advance_hash[:hours] = section.end.hour
          end
          converted_section_end_time = Time.now.beginning_of_week.advance(advance_hash)
          if Time.now > converted_section_end_time and converted_section_end_time > section.updated_at
            section.temp_end = nil
            section.temp_start = nil
            section.temp_date = nil
            section.temp_location = nil
            section.save
          end

        end
      end
    end
  end
end
