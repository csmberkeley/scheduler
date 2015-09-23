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
    sections = Section.where(course_id: self.course_id).where.not(id: self.id)
    open_sections = []
    sections.each do |section|
      if section.enrolls.size < section.getLimit()
        open_sections << section
      end
    end
    return open_sections
  end
  def isFull()
    return self.enrolls.size >= self.getLimit()
  end
  def getAllOtherSections()
    return Section.where(course_id: self.course_id).where.not(id: self.id)
  end
  def getStudentCount()
    return self.enrolls.length
  end
  def getDay()
      return self.date
  end
  def getLimit()
    limit = 5
    course = Course.find(self.course_id)
    setting = Setting.find_by(name:"limit")
    if self.limit
      return self.limit
    elsif course and course.limit
      return course.limit
    elsif setting and setting.value
      return setting.value.to_i
    else
    return limit
    end
  end
end
