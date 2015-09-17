class UserMailer < ActionMailer::Base
  default from: "csmberkeley@gmail.com"
  def section_email(section) 
    recipients = []
    @section = section
    Enroll.where(section_id: section.id).each do |enroll| 
      @user = User.find(enroll.user_id)
      recipients << @user.email
    end
    if recipients.size > 0
      mail(to: recipients, subject: "[CSM] Section Information")
    end
  end
end
