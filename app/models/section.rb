class Section < ActiveRecord::Base


  has_many :enrolls
  has_many :requests, dependent: :destroy
  # has_many :users  <- This causes complications because there is no belongs_to in user model?
  # Trying to do section.users << current_user will not save. See seed file
  # To get users in a section, use enrollment table. This is the safest option.
  has_many :offers, dependent: :destroy
  has_many :wants, dependent: :destroy
  belongs_to :course

  def getOtherOpenSections()
  	return Section.where(empty: true, course_id: self.course_id).where.not(id: self.id)
  end

  def getAllOtherSections()
    return Section.where(course_id: self.course_id).where.not(id: self.id)
  end
  def getStudentCount()
    return self.enrolls.length
  end
  def getDay()
      number = self.name.split.last.to_i
      day_of_the_week = number / 100 % 10
      day = ''
      case day_of_the_week
      when 0
        day = 'Monday'
      when 1
        day = 'Tuesday'
      when 2
        day = 'Wednesday'
      when 3
        day = 'Thursday'
      when 4
        day = 'Friday'
      else
        day = 'N/A'
      end
      return day
  end

end
