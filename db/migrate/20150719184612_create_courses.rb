class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :course_name
      t.string :semester
      t.integer :year
      t.string :password

      t.timestamps
    end
  end
end
