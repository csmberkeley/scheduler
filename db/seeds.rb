# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create! :email => "admin@csm.com",
             :password => "el psy congroo",
             :password_confirmation => "el psy congroo"

admin.admin = true
admin.save

#mike's test data for courses controller

mike = User.create! :email => "mikeaboody@berkeley.edu",
            :password => "mikespassword",
            :password_confirmation => "mikespassword"
cs61a = Course.create! :course_name => "CS61A",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"

cs61b = Course.create! :course_name => "CS61B",
			:semester => "Fall",
			:year => 2014,
			:password => "pass"



cs61a_enr = Enroll.create! :user_id => mike.id,
			:course_id => cs61a.id,
			:tutor => false

mike.enrolls << cs61a_enr

cs61b_enr = Enroll.create! :user_id => mike.id,
			:course_id => cs61b.id,
			:tutor => false

mike.enrolls << cs61b_enr

cs61a_recursion = Topic.create! :course_id => cs61a.id,
			:name => "Recursion"
cs61a.topics << cs61a_recursion
cs61a_hof = Topic.create! :course_id => cs61a.id,
			:name => "HOF"
cs61a.topics << cs61a_hof
cs61b_hashmaps = Topic.create! :course_id => cs61b.id,
			:name => "Hash Maps"
cs61b.topics << cs61b_hashmaps
cs61b_llrb = Topic.create! :course_id => cs61b.id,
			:name => "LLRB"
cs61b.topics << cs61b_llrb

cs61a.save
cs61b.save
cs61a_enr.save
cs61b_enr.save
cs61a_recursion.save
cs61a_hof.save
cs61b_hashmaps.save
cs61b_llrb.save
mike.save
