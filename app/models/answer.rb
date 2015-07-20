class Answer < ActiveRecord::Base
  belongs_to :feedback
  belongs_to :question
end
