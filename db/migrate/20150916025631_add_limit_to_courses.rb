class AddLimitToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :limit, :integer
  end
end
