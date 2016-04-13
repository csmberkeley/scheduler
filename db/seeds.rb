# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Always have an admin account, don't delete (can change credentials if you'd like).
# See README for storing passwords and generating secret keys, ENV[] needs to reference values
# in application.yml, a file you need to create yourself.

admin = User.create! :name => "Admin",
                     :email => "csmberkeley@gmail.com",
                     :password => ENV["ADMIN_PASS"],
                     :password_confirmation => ENV["ADMIN_PASS"],
                     :confirmed_at => "2015-09-09 02:50:19"
admin.admin = true
admin.save

#test data

user1 = User.create! :name => "John Smith",
                     :email => "jsmith@berkeley.edu",
                     :password => ENV["USER_1_PASS"],
                     :password_confirmation => ENV["USER_1_PASS"],
                     :confirmed_at => "2015-09-09 02:50:19"

user2  = User.create! :name => "Andrew Huang",
                     :email => "ahuang@berkeley.edu",
                     :password => ENV["USER_2_PASS"],
                     :password_confirmation => ENV["USER_2_PASS"],
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

cs70  = Course.create! :course_name => "CS70",
                       :semester => "Spring",
                       :year => 2016,
                       :password => "pass",
                       :description => "Discrete Mathematics and Probability Theory",
                       :instructor => "Satish Rao"

data8 = Course.create! :course_name => "Data8",
                       :semester => "Spring",
                       :year => 2016,
                       :password => "pass",
                       :description => "Foundations of Data Science",
                       :instructor => "John DeNero"

# Useful week constants.
weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
tuth = ["Tuesday", "Thursday"]
mwf = weekdays - tuth

###############################################################################
# Course-specific configs ***modify these***
###############################################################################
# To modify course information, pick:
# - section days (list of strings: e.g. ["Tuesday", "Thursday"]),
# - section times (list of list of times,
#   e.g. [[11, 00, 13, 00], [13, 00, 15, 00]] is 11am to 1pm and 1pm to 3pm),
# - lecture days (same format as section days),
# - lecture times (list of times, e.g. [11, 00, 13, 00] is 11am to 1pm), and
# - repeats (some positive number)
#
# **Number of repeats** sections will be created at **each section time** on
# **each section day** that does not overlap with lecture.
#
# P.S. Yes, 00 and 0 are technically the same... but 00 looks nicer!

# CS61A
# 1 hr sections. First is 10:00-11:00, last is 17:00-18:00
cs61a_sec_days  = weekdays
cs61a_sec_times = (10..17).flat_map { |x| [[x, 00, x + 1, 00]] }
cs61a_lec_days  = mwf
cs61a_lec_times = [14, 00, 15, 00]
cs61a_repeats   = 2

# CS61B
# 1 hr sections. First is 10:00-11:00, last is 17:00-18:00
cs61b_sec_days  = weekdays
cs61b_sec_times = (10..17).flat_map { |x| [[x, 00, x + 1, 00]] }
cs61b_lec_days  = mwf
cs61b_lec_times = [15, 00, 16, 00]
cs61b_repeats   = 1

# CS70
# 1.5 hr sections. First is 9:30-11:00, last is 17:00-18:30
# Generate two sections at a time, hence the step size.
cs70_sec_days  = weekdays
cs70_sec_times = (9..15).step(3).flat_map { |x| [[x, 30, x+2, 00], [x+2, 00, x+3, 30]] }
cs70_lec_days  = tuth
cs70_lec_times = [12, 30, 14, 00]
cs70_repeats   = 1

# Data8
# 0.5 hr sections. First is 10:00-10:30, last is 4:30-5:00
# Generate two sections at a time (but they're within the hour, so no addl step)
data8_sec_days  = weekdays
data8_sec_times = (10..16).flat_map { |x| [[x, 00, x, 30], [x, 30, x+1, 00]] }
data8_lec_days  = mwf
data8_lec_times = [10, 00, 11, 00]
data8_repeats   = 1

###############################################################################
# Seeding Generation (you should not need to modify these)
###############################################################################

# Generic seeding pattern for any CSM mentored course.
def seed_class(course:, repeats: 1, sec_days:, sec_times:, lec_days:, lec_times:)
  # Try to create every potential section time.
  # Keep those that don't interfere with lecture.
  count = 1
  sec_days.each do |d|
    sec_times.each do |hs, ms, he, me| # Hour/min start, hour/min end
      lhs, lms, lhe, lme = lec_times
      # Create time objects for comparing section time and lecture time.
      lec_start = Time.parse("#{lhs}:#{lms}")
      lec_end   = Time.parse("#{lhe}:#{lme}")
      sec_start = Time.parse("#{hs}:#{ms}")
      sec_end   = Time.parse("#{he}:#{me}")
      # Create a section if it's not during lecture time.
      if not lec_days.include?(d) or (lec_start >= sec_end) or (lec_end <= sec_start)
        for _ in (1..repeats) # Number of sections per timeslot.
          Section.create! :name => "Section #{count}",
                          :course_id => course.id,
                          :start => Time.new(2015, 9, 9, hs, ms, 0, "+00:00"),
                          :end => Time.new(2015, 9, 9, he, me, 0, "+00:00"),
                          :date => d,
                          :location => "TBD"
          count += 1
        end
      end
    end
  end
end

# CS61A
seed_class(course: cs61a,
           repeats: cs61a_repeats,
           sec_days: cs61a_sec_days,
           sec_times: cs61a_sec_times,
           lec_days: cs61a_lec_days,
           lec_times: cs61a_lec_times)

# CS61B
seed_class(course: cs61b,
           repeats: cs61b_repeats,
           sec_days: cs61b_sec_days,
           sec_times: cs61b_sec_times,
           lec_days: cs61b_lec_days,
           lec_times: cs61b_lec_times)

# CS70
seed_class(course: cs70,
           repeats: cs70_repeats,
           sec_days: cs70_sec_days,
           sec_times: cs70_sec_times,
           lec_days: cs70_lec_days,
           lec_times: cs70_lec_times)

# Data8
seed_class(course: data8,
           repeats: data8_repeats,
           sec_days: data8_sec_days,
           sec_times: data8_sec_times,
           lec_days: data8_lec_days,
           lec_times: data8_lec_times)

# Necessary state information, don't delete/change unless you know what you're doing

Setting.create! :setting_name => "Enable Comments", :setting_type => "boolean", :value => "1", :name => "comments"

Setting.create! :setting_name => "Enable Section Switching", :setting_type => "boolean", :value => "1", :name => "section"

Setting.create! :setting_name => "Section Limit", :setting_type => "int", :value => "5", :name => "limit"

Setting.create! :setting_name => "Silent Add/Drop", :setting_type => "boolean", :value => "0", :name => "silent"

Setting.create! :setting_name => "Base Week", :setting_type => "String", :value => "2016-1-18 14:46:21 +0100", :name => "start_week"

Setting.create! :setting_name => "Max Week", :setting_type => "int", :value => "15", :name => "max_week"

Setting.create! :setting_name => "Enable Mentors to Change Default Section Time/Location", :setting_type => "boolean", :value => "1", :name => "default_switching"

Setting.create! :setting_name => "Enable Announcement", :setting_type => "boolean", :value => "1", :name => "announcement"

Announcement.create! :info => "<p> Hi this is stuff on the home page </p>"




