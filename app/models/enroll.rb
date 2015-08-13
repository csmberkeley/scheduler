class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :courses
  belongs_to :section

  def enrollUserInSection(current_user, section)
  	if not section.empty
  		return false
  	end
  	section.enrolls << self
  	section.users << current_user
  	if section.users.length >= 6
  		section.empty = false
  	end
  	return true
  end

  def unenrollUserInSection(current_user, section)
  	section.users.delete(current_user)
  	section_offer = Offer.getUserOfferFromSection(current_user, section)
  	if section_offer
  		section_offer.destroy
  	end
  end

  def switchSection(old_section, new_section, current_user)
  	if not self.enrollUserInSection(current_user, new_section)
  		return false
  	end
  	self.unenrollUserInSection(current_user, old_section)
  	return true
  end
end
