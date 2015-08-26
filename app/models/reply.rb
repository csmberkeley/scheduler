class Reply < ActiveRecord::Base
  belongs_to :user
  belongs_to :offer

  def getEnrollmentOfReplier
  	replier = User.find(self.user_id)
  	offer = Offer.find(self.offer_id)
  	section = Section.find(offer.section_id)
  	course = Course.find(section.course_id)
  	replier.enrolls.each do |e|
  		if e.course_id == course.id
  			return e
  		end
  	end
  	return nil
  end
end
