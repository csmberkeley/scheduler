class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :courses
  belongs_to :section

  def switchSection(old_section, new_section, current_user)
  	new_section.enrolls << self
  	old_section.users.delete(current_user)
  end
end
