class Topic < ActiveRecord::Base
  belongs_to :course
  has_many_and_belongs_to :sessions, join_table: :sessions_topics
end
