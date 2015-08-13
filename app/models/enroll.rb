class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :courses
  belongs_to :section

  def switchSection(old_section, new_section, current_user)
  	if not new_section.empty
  		return false
  	end
  	new_section.enrolls << self
  	new_section.users << current_user
  	if new_section.users.length >= 6
  		new_section.empty = false
  	end
  	old_section.users.delete(current_user)
  	old_offer = Offer.getUserOfferFromSection(current_user, old_section)
  	if old_offer
  		old_offer.destroy
  	end
  	return true
  end
end
