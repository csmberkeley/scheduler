class UserMailer < ActionMailer::Base
  default from: "csmberkeley@gmail.com"
  def section_email(section) 
    Enroll.where(section_id: section.id).each do |enroll| 
      @user = User.find(enroll.user_id)
      @section = section
      mail(to: @user.email, subject: "[CSM] Section Information")
    end
  end
end
