class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :section
  has_many :transactions

  def enrollUserInSection(section)
  	if not section.empty
  		return false
  	end
  	section.enrolls << self
    user = User.find(self.user_id)
  	section.users << user
  	if section.users.length >= 6
  		section.empty = false
  	end
  	return true
  end

  def unenrollUserInSection()
    user = User.find(self.user_id)
    section = Section.find(self.section_id)
  	section.users.delete(user)
  	section_offer = self.getOffer
  	if section_offer
  		section_offer.destroy
  	end
  end

  def switchSection(new_section)
  	if not self.enrollUserInSection(new_section)
  		return false
  	end
  	self.unenrollUserInSection
  	return true
  end

  def tradeSection(other_enrollment)
    this_user_section = Section.find(self.section_id)
    other_user_section = Section.find(other_enrollment.section_id)
    self.switchSection(other_user_section)
    other_enrollment.switchSection(this_user_section)
  end

  def getOffer
    user = User.find(self.user_id)
    section = Section.find(self.section_id)
    request_offers = user.offers.where(section_id: section.id)
    if request_offers.length > 0
      return request_offers[0]
    end
    return nil
  end

  def createTransaction(body)
    new_transaction = Transaction.create! body: body
    self.transactions << new_transaction
    user = User.find(self.user_id)
    user.transactions << new_transaction
  end
end
