# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create! :name => "Admin",
			 :email => "admin@csm.com",
             :password => "el psy congroo",
             :password_confirmation => "el psy congroo"

admin.admin = true
admin.save

#mike's test data

mike = User.create! :name => "Mike Aboody",
			:email => "mikeaboody@berkeley.edu",
            :password => "mikespass",
            :password_confirmation => "mikespass"
mike_cs61a = Course.create! :course_name => "CS61A",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"

mike_cs61b = Course.create! :course_name => "CS61B",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"



mike_cs61a_enr = Enroll.create! :user_id => mike.id,
			:course_id => mike_cs61a.id

mike.enrolls << mike_cs61a_enr

mike_cs61b_enr = Enroll.create! :user_id => mike.id,
			:course_id => mike_cs61b.id

mike.enrolls << mike_cs61b_enr

mike_cs61a_section1 = Section.create! :name => "Section 1022", 
      :course_id => mike_cs61a_enr.course_id, :empty => true

mike_cs61a_section2 = Section.create! :name => "Section 1023", 
      :course_id => mike_cs61a_enr.course_id, :empty => true

mike_cs61a_section3 = Section.create! :name => "Section 1026", 
      :course_id => mike_cs61a_enr.course_id, :empty => true

mike_cs61b_section1 = Section.create! :name => "Section 1024", 
      :course_id => mike_cs61b_enr.course_id, :empty => true

mike_cs61b_section2 = Section.create! :name => "Section 1025", 
      :course_id => mike_cs61b_enr.course_id, :empty => false

mike_cs61b_section3 = Section.create! :name => "Section 1027", 
      :course_id => mike_cs61b_enr.course_id, :empty => true

mike_cs61a_section1.users << mike
mike_cs61b_section1.users << mike

mike_cs61a_section1.enrolls << mike_cs61a_enr
mike_cs61b_section1.enrolls << mike_cs61b_enr

mike_cs61a_offer = Offer.create! :body => "61A Section 1022 Offer", 
      :status => "pending",
      :section_id => mike_cs61a_section1.id,
      :user_id => mike.id 



