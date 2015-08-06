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

#mike's test data for courses controller

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
			:course_id => mike_cs61a.id,
			:tutor => false

mike.enrolls << mike_cs61a_enr

mike_cs61b_enr = Enroll.create! :user_id => mike.id,
			:course_id => mike_cs61b.id,
			:tutor => false

mike.enrolls << mike_cs61b_enr

mike_cs61a_section1 = Section.create! :name => "61a-1"
mike_cs61a_section2 = Section.create! :name => "61a-2"
mike_cs61b_section1 = Section.create! :name => "61b-1"
mike_cs61b_section2 = Section.create! :name => "61b-2"

mike_cs61a_section1.save
mike_cs61a_section2.save
mike_cs61b_section1.save
mike_cs61b_section2.save


mike_cs61a.save
mike_cs61b.save
mike_cs61a_enr.save
mike_cs61b_enr.save

