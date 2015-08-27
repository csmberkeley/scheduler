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
    offerer = User.find(self.user_id)
    section = Section.find(self.section_id)
    course = Course.find(section.course_id)
    offerer.enrolls.each do |e|
      if e.course_id == course.id
        return e
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
end
