# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.create! :name => "Admin",
			 :email => "csmberkeley@gmail.com",
             :password => ENV["ADMIN_PASS"],
             :password_confirmation => ENV["ADMIN_PASS"],
             :confirmed_at => "2015-09-09 02:50:19"
admin.admin = true
admin.save

#mike's test data

allan = User.create! :name => "Allan Tang",
            :email => "allan_tang@berkeley.edu",
            :password => ENV["USER_ALLAN_PASS"],
            :password_confirmation => ENV["USER_ALLAN_PASS"],
            :confirmed_at => "2015-09-09 02:50:19"


mike = User.create! :name => "Mike Aboody",
			:email => "mikeaboody@berkeley.edu",
            :password => ENV["USER_MIKE_PASS"],
            :password_confirmation => ENV["USER_MIKE_PASS"],
            :confirmed_at => "2015-09-09 02:50:19",
            :admin => "true"

cs61a = Course.create! :course_name => "CS61A",
			:semester => "Spring",
			:year => 2016,
			:password => "pass",
                  :description => "Structure and Interpretation of Computer Programs",
                  :instructor => "Paul Hilfinger"

cs61b = Course.create! :course_name => "CS61B",
			:semester => "Spring",
			:year => 2016,
			:password => "pass",
                  :description => "Data Structures",
                  :instructor => "Josh Hug"

cs70 = Course.create! :course_name => "CS70",
      :semester => "Spring",
      :year => 2016,
      :password => "pass",
                  :description => "Discrete Mathematics and Probability Theory",
                  :instructor => "Satish Rao"

#cs61a
days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
count = 1
days.each do |d|
      times = [10, 11, 12, 13, 14, 15, 16, 17]
      times.each do |t|
            Section.create! :name => "Section #{count}", 
      :course_id => cs61a.id, :start => Time.new(2015,9,9, t,0,0, "+00:00"),:end => Time.new(2015,9,9, t+1,0,0, "+00:00"),
      :date => d, :location => "TBD"
            count += 1
            Section.create! :name => "Section #{count}", 
      :course_id => cs61a.id, :start => Time.new(2015,9,9, t,0,0, "+00:00"),:end => Time.new(2015,9,9, t+1,0,0, "+00:00"),
      :date => d, :location => "TBD"
            count += 1
      end 
end

#cs61b
days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
count = 1
days.each do |d|
     times = [10, 11, 12, 13, 14, 15, 16, 17]
     times.each do |t|
           Section.create! :name => "Section #{count}", 
     :course_id => cs61b.id, :start => Time.new(2015,9,9, t,0,0, "+00:00"),:end => Time.new(2015,9,9, t+1,0,0, "+00:00"),
     :date => d, :location => "TBD"
           count += 1
     end 
end

#cs70
# hour and half blocks, which requires some fishy array setup to make sure time blocks are set up correctly
days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
count = 1
days.each do |d|
     times = [[9,30,11,0], [11,0,12,30], [12,30,14,0], [14,0,15,30], [15,30,17,0], [17,0,18,30]]
     times.each do |t1, m1, t2, m2|
           Section.create! :name => "Section #{count}", 
     :course_id => cs70.id, :start => Time.new(2015,9,9, t1,m1,0, "+00:00"),:end => Time.new(2015,9,9, t2,m2,0, "+00:00"),
     :date => d, :location => "TBD"
           count += 1
     end 
end

Setting.create! :setting_name => "Enable Comments", :setting_type => "boolean", :value => "1", :name => "comments"

Setting.create! :setting_name => "Enable Section Switching", :setting_type => "boolean", :value => "1", :name => "section"

Setting.create! :setting_name => "Section Limit", :setting_type => "int", :value => "5", :name => "limit"

Setting.create! :setting_name => "Silent Add/Drop", :setting_type => "boolean", :value => "0", :name => "silent"

Setting.create! :setting_name => "Base Week", :setting_type => "String", :value => "2016-1-18 14:46:21 +0100", :name => "start_week"

Setting.create! :setting_name => "Max Week", :setting_type => "int", :value => "15", :name => "max_week"

Setting.create! :setting_name => "Enable Mentors to Change Default Section Time/Location", :setting_type => "boolean", :value => "1", :name => "default_switching"

Setting.create! :setting_name => "Enable Announcement", :setting_type => "boolean", :value => "1", :name => "announcement"

Announcement.create! :info => "<p> Hi this is stuff on the home page </p>"




