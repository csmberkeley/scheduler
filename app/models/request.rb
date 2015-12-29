class Request < ActiveRecord::Base

  #Depricated because now students signup via first come first serve

  belongs_to :user
  belongs_to :section
end
