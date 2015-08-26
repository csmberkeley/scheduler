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

mike2 = User.create! :name => "Mike Aboody2",
      :email => "mikeaboody@gmail.com",
            :password => "mikespass",
            :password_confirmation => "mikespass"

cs61a = Course.create! :course_name => "CS61A",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"

cs61b = Course.create! :course_name => "CS61B",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"



mike_cs61a_enr = Enroll.create! :user_id => mike.id,
			:course_id => cs61a.id
mike2_cs61a_enr = Enroll.create! :user_id => mike2.id,
      :course_id => cs61a.id

mike.enrolls << mike_cs61a_enr
mike2.enrolls << mike2_cs61a_enr

mike_cs61b_enr = Enroll.create! :user_id => mike.id,
			:course_id => cs61b.id
mike2_cs61b_enr = Enroll.create! :user_id => mike2.id,
      :course_id => cs61b.id

mike.enrolls << mike_cs61b_enr
mike2.enrolls << mike2_cs61b_enr

mike_cs61a_section1 = Section.create! :name => "Section 1022", 
      :course_id => cs61a.id, :empty => true

mike_cs61a_section2 = Section.create! :name => "Section 1023", 
      :course_id => cs61a.id, :empty => true

mike_cs61a_section3 = Section.create! :name => "Section 1026", 
      :course_id => cs61a.id, :empty => true

mike_cs61b_section1 = Section.create! :name => "Section 1024", 
      :course_id => cs61b.id, :empty => true

mike_cs61b_section2 = Section.create! :name => "Section 1025", 
      :course_id => cs61b.id, :empty => false

mike_cs61b_section3 = Section.create! :name => "Section 1027", 
      :course_id => cs61b.id, :empty => true

mike_cs61a_section1.users << mike
mike_cs61b_section1.users << mike

mike_cs61a_section2.users << mike2
mike_cs61b_section2.users << mike2

mike_cs61a_section1.enrolls << mike_cs61a_enr
mike_cs61b_section1.enrolls << mike_cs61b_enr

mike_cs61a_section2.enrolls << mike2_cs61a_enr
mike_cs61b_section2.enrolls << mike2_cs61b_enr

mike_cs61a_offer = Offer.create! :body => "61A Section 1022 Offer", 
      :accepted => false,
      :section_id => mike_cs61a_section1.id,
      :user_id => mike.id 
Want.create! :offer_id => mike_cs61a_offer.id,
      :section_id => mike_cs61a_section2.id
Want.create! :offer_id => mike_cs61a_offer.id,
      :section_id => mike_cs61a_section3.id


allan = User.create! :name => "Allan Tang",
            :email => "allan_tang@berkeley.edu",
            :password => "allanpass",
            :password_confirmation => "allanpass"

allan_cs61a_enr = Enroll.create! :user_id => allan.id,
                  :course_id => cs61a.id

allan.enrolls << allan_cs61a_enr
