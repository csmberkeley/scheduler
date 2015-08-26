class Comment < ActiveRecord::Base
  belongs_to :offer
  belongs_to :user

  def getEnrollmentOfCommenter
  	commenter = User.find(self.user_id)
  	offer = Offer.find(self.offer_id)
  	section = Section.find(offer.section_id)
  	course = Course.find(section.course_id)
  	commenter.enrolls.each do |e|
  		if e.course_id == course.id
  			return e
  		end
  	end
  	return nil
  end
end
