class Enroll < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  belongs_to :section
  has_many :transactions, dependent: :destroy
  has_one :offer, dependent: :destroy

  def enrollUserInSection(section)
  	if section.enrolls.length >= Setting.find_by(name: 'limit').value.to_i
  		return false
  	else
      section.enrolls << self
      return true
    end
  	
  end

  def unenrollUserInSection()
    user = User.find(self.user_id)
    section = Section.find(self.section_id)
  	if self.offer
  		self.offer.destroy
  	end
    self.removeAllReplies
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
    self.removeAllReplies
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
  def removeAllReplies()
    course = Course.find(self.course_id)
    course.sections.each do |section|
      section.offers.each do |offer|
        reply = offer.getReplyFrom(self)
        if reply
          reply.destroy
        end
      end
    end

  end

end
