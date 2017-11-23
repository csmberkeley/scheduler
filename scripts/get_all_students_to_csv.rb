require 'csv'
CSV.open("student.csv", "w") do |csv|
  	csv << ["name", "course", "email", "attendance"]
	for section in Section.all
		for enroll in section.enrolls
			name = User.find_by(id: enroll.user_id).name
			course = Course.find_by(id: enroll.course_id).course_name
			email = User.find_by(id: enroll.user_id).email
			attendances = enroll.attendances.where(status: 0).count + enroll.attendances.where(status: 1).count
  			csv << [name, course, email, attendances]
  		end
  	end
end
CSV.open("cs61a_student.csv", "w") do |csv|
  	csv << ["name", "course", "email", "attendance"]
	for section in Section.all.where(course_id: d4)
		for enroll in section.enrolls
			name = User.find_by(id: enroll.user_id).name
			course = Course.find_by(id: enroll.course_id).course_name
			email = User.find_by(id: enroll.user_id).email
			attendances = enroll.attendances.where(status: 0).count + enroll.attendances.where(status: 1).count
  			csv << [name, course, email, attendances]
  		end
  	end
end