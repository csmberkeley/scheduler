class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :enrolls, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :requests, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :jenrolls, dependent: :destroy
  has_many :senrolls, dependent: :destroy

  def getEnrollmentInCourse(course)
  	self.enrolls.each do |e|
  		if e.course_id == course.id
  			return e
  		end
  	end
  	return nil
  end

  def getMentorEnrollmentsInCourse(course)
    enrolls = []
    self.jenrolls.each do |j|
      if j.course_id == course.id
        enrolls << j
      end
    end
    self.senrolls.each do |s|
      if s.course_id == course.id
        enrolls << s
      end
    end
    return enrolls
  end
end