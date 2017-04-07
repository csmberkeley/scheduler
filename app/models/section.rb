class Section < ActiveRecord::Base


  has_many :enrolls
  has_many :requests, dependent: :destroy
  # has_many :users  <- This causes complications because there is no belongs_to in user model?
  # Trying to do section.users << current_user will not save. See seed file
  # To get users in a section, use enrollment table. This is the safest option.
  has_many :offers, dependent: :destroy
  has_many :wants, dependent: :destroy
  belongs_to :course
  has_one :jenroll
  has_one :senroll

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

  def self.getSectionsWithoutMentor(course)
    sections = []
    course.sections.each do |section|
      if section.getMentor() == nil
        sections << section
      end
    end

    #Sort the sections by day, then time
    monday = []
    tuesday = []
    wednesday = []
    thursday = []
    friday = []
    sections.each do |section|
      case section.getDay
      when "Monday"
        monday << section
      when "Tuesday"
        tuesday << section
      when "Wednesday"
        wednesday << section
      when "Thursday"
        thursday << section
      else
        friday << section
      end
    end

    monday.sort!{|a,b| a.start && b.start ? a.start <=> b.start : a.start ? -1 : 1 }
    tuesday.sort!{|a,b| a.start && b.start ? a.start <=> b.start : a.start ? -1 : 1 }
    wednesday.sort!{|a,b| a.start && b.start ? a.start <=> b.start : a.start ? -1 : 1 }
    thursday.sort!{|a,b| a.start && b.start ? a.start <=> b.start : a.start ? -1 : 1 }
    friday.sort!{|a,b| a.start && b.start ? a.start <=> b.start : a.start ? -1 : 1 } 

    sections = monday + tuesday + wednesday + thursday + friday
    return sections
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

  def getMentor()
    if self.senroll != nil
      return self.senroll
    elsif self.jenroll != nil
      return self.jenroll
    end
    return nil
  end

  def getMentorName()
    if self.getMentor() != nil
      return User.find(self.getMentor().user_id).name
    end
    return "TBD"
  end

  def getMentorEmail()
    if self.getMentor() != nil
      return User.find(self.getMentor().user_id).email
    end
    return "TBD"
  end

  def assignMentor(mentorenroll)
    if self.getMentor() != nil
      return nil
    end
    if mentorenroll.is_a?(Senroll)
      self.senroll = mentorenroll
    else
      self.jenroll = mentorenroll
    end
    mentorenroll.save
    return mentorenroll
  end

  def getDate(week)
    date = start + 7.days * (week - 1)
    return "#{Date::MONTHNAMES[date.month]} #{date.day}"
  end
end
