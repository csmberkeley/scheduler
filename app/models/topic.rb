class Topic < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :sessions, join_table: :sessions_topics
end
