class Section < ActiveRecord::Base


  has_many :enrolls, dependent: :destroy
  has_many :requests, dependent: :destroy
  #Note: Don't want to delete users from database even if section is destroyed 
  has_many :users 
  has_many :offers, dependent: :destroy
  has_many :wants, dependent: :destroy
  belongs_to :course

  def getOtherOpenSections()
  	return Section.where(empty: false, course_id: self.course_id).where.not(id: self.id)
  end

end
