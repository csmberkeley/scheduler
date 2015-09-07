class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :section
  has_many :transactions, dependent: :destroy
  has_one :offer, dependent: :destroy

  def enrollUserInSection(section)
  	if not section.empty
  		return false
  	end
  	section.enrolls << self
  	if section.enrolls.length >= Setting.find_by(name: 'limit').value.to_i
  		section.empty = false
  	end
  	return true
  end

  def unenrollUserInSection()
    user = User.find(self.user_id)
    section = Section.find(self.section_id)
  	if self.offer
  		self.offer.destroy
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

  def createTransaction(body)
    new_transaction = Transaction.create! body: body
    self.transactions << new_transaction
    user = User.find(self.user_id)
    user.transactions << new_transaction
  end

  def getTransactionsInReverseOrder()
    return self.transactions.order(:created_at).reverse_order
  end

  def hasSection()
    if self.section_id and Section.exists?(self.section_id)
      return true
    end
    return false
  end

end
