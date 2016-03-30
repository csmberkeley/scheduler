class AddBaseWeekToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :base_week, :string
  end
end
