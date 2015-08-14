class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_many :replies, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :comments, dependent: :destroy

  def getCommentsInReverseOrder()
  	return self.comments.order(:created_at).reverse_order
  end

  def self.getUserOfferFromSection(current_user, section)
  	request_offers = current_user.offers.where(section_id: section.id)
  	if request_offers.length > 0
  		return request_offers[0]
  	end
  	return nil
  end

  #untested:
  def self.getCompatableOffers(current_section)
    compatable_offers = []
    #getting compatable offers from all other sections
    current_section.getAllOtherSections.each do |section|
      section.wants.each do |want|
        if want.section_id == current_section.id
          compatable_offers << Offer.find(want.offer_id)
        end
      end
    end
    return compatable_offers
  end
end
