class AdminsController < ApplicationController
  def index
    @students = User.all      
  end

  def manage_sections
    # final product
    @sections = {} 
    Course.all.each do | course |
      @sections[course.course_name] = { "Monday" => [], "Tuesday" => [], "Wednesday" => [], 
        "Thursday" => [], "Friday" => [] }
      course.sections.each do | section |
        number = section.name.split.last.to_i
        day_of_the_week = number / 100 % 10
        case day_of_the_week
        when 0
          @sections[course.course_name]["Monday"] << section
        when 1
          @sections[course.course_name]["Tuesday"] << section
        when 2
          @sections[course.course_name]["Wednesday"] << section
        when 3
          @sections[course.course_name]["Thursday"] << section
        when 4
          @sections[course.course_name]["Friday"] << section
        else
          next
        end
      end
    end
  end

end
