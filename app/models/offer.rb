class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_many :replies, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :comments, dependent: :destroy

  def getCommentsInReverseOrder()
  	return self.comments.order(:created_at).reverse_order
  end

   def getRepliesInOrder()
    return self.replies.order(:created_at)
  end

  def self.getUserOfferFromSection(current_user, section)
  	request_offers = current_user.offers.where(section_id: section.id)
  	if request_offers.length > 0
  		return request_offers[0]
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
