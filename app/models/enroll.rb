class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :courses
  belongs_to :section

  def enrollUserInSection(user, section)
  	if not section.empty
  		return false
  	end
  	section.enrolls << self
  	section.users << user
  	if section.users.length >= 6
  		section.empty = false
  	end
  	return true
  end

  def unenrollUserInSection(user, section)
  	section.users.delete(user)
  	section_offer = Offer.getUserOfferFromSection(user, section)
  	if section_offer
  		section_offer.destroy
  	end
  end

  def switchSection(old_section, new_section, user)
  	if not self.enrollUserInSection(user, new_section)
  		return false
  	end
  	self.unenrollUserInSection(user, old_section)
  	return true
  end

  def tradeSection(other_enrollment)
    this_user = User.find(self.user_id)
    other_user = User.find(other_enrollment.user_id)
    this_user_section = Section.find(self.section_id)
    other_user_section = Section.find(other_enrollment.section_id)
    self.switchSection(this_user_section, other_user_section, this_user)
    other_enrollment.switchSection(other_user_section, this_user_section, other_user)
  end
end
