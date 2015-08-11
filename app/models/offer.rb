class Offer < ActiveRecord::Base
  belongs_to :user
  belongs_to :section
  has_many :replies, dependent: :destroy
  has_many :wants, dependent: :destroy
  has_many :comments, dependent: :destroy

  def getCommentsInReverseOrder()
  	return self.comments.order(:created_at).reverse_order
  end

end
