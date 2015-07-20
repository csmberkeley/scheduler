class Session < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_and_belongs_to_many :topics, join_table: :sessions_topics
end
