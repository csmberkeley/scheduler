class Session < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many_and_belongs_to :topics, join_table: :sessions_topics
end
