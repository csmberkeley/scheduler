class Want < ActiveRecord::Base
	belongs_to :offer
	belongs_to :section
end
