class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  belongs_to :enroll
  has_many :replies, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :comments, dependent: :destroy

  def getCommentsInReverseOrder()
  	return self.comments.order(:created_at).reverse_order
  end

  def getRepliesInOrder()
    return self.replies.order(:created_at)
  end

  def getEnrollmentOfOfferer()
    return Enroll.find(self.enroll_id)
  end

  def hasReplyFrom(enroll)
    self.replies.each do |r|
      if r.getEnrollmentOfReplier.id = enroll.id
        return true
      end
    end
    return false
  end
  def getReplyFrom(enroll)
    self.replies.each do |r|
      if r.getEnrollmentOfReplier.id = enroll.id
        return r
      end
    end
    return nil
  end

  def self.getCompatableOffers(current_section)
    compatable_offers = []
    current_section.wants.each do |want|
      compatable_offers << Offer.find(want.offer_id)
    end
    return compatable_offers
  end

  def getWantedSections()
    wanted_sections = []
    self.wants.each do |want|
      wanted_sections << Section.find(want.section_id)
    end
    return wanted_sections
  end

  def createWants(section_ids)
    section_ids.each do |id|
      curr_want = Want.create(section_id: id)
      self.wants << curr_want
    end
  end
end
