class Feedback < ActiveRecord::Base
  belongs_to :session
  has_many :answers, dependent: :destroy
end
