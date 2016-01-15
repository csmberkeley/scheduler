class UserMailer < ActionMailer::Base
  default from: "csmberkeley@gmail.com"
  def section_email(section) 
    recipients = []
    @section = section
    @course = Course.find(@section.course_id)
    Enroll.where(section_id: section.id).each do |enroll| 
      @user = User.find(enroll.user_id)
      recipients << @user.email
    end
    if recipients.size > 0
      mail(to: recipients, subject: "[CSM] Section Information")
    end
  end
  def mentor_email(section)
    @section = section
    @students = []
    Enroll.where(section_id: section.id).each do |enroll| 
      @students << User.find(enroll.user_id)       
    end
    @course = Course.find(@section.course_id)
    if @students.size > 0
      mail(to: @section.mentor_email, subject: "[CSM] About Your Section")
    end
  end
  def drop_email(student, section)
    @student = student
    @section = section
    @course = Course.find(@section.course_id)
    mail(to: @student.email, subject: "[CSM] You have been dropped from your section")
  end
  def add_email(student, section)
    @student = student
    @section = section
    @course = Course.find(@section.course_id)
    mail(to: @student.email, subject: "[CSM] You have been added to " + @section.name)
  end
  def timeloc_change_email(user, section, time_change, location_change)
    @section = section
    @user = user
    @time_change = time_change
    @time_default_change = false
    if @time_change and section.temp_start == section.start and section.temp_end == section.end and section.temp_date == section.date
      @time_default_change = true
    end
    @location_change = location_change
    @location_default_change = false
    if @location_change and section.location == section.temp_location
      @location_default_change = true
    end
    subject = nil
    if time_change and location_change
      subject = "[CSM] Your section time and location has changed"
    elsif time_change
      subject = "[CSM] Your section time has changed"
    else
      subject = "[CSM] Your section location has changed"
    end
    mail(to: @user.email, subject: subject)
  end

  def time_remove_email(user, section)
    @user = user
    @section = section
    mail(to: @user.email, subject: "[CSM] Your section time has changed")
  end

  def location_remove_email(user, section)
    @user = user
    @section = section
    mail(to: @user.email, subject: "[CSM] Your section location has changed")
  end

end
