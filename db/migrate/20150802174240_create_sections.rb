class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.time :start
      t.time :end
      t.time :temp_start
      t.time :temp_end
      t.string :date
      t.string :temp_date
      t.boolean :empty
      t.integer :course_id
      t.string :location
      t.string :temp_location

      t.timestamps
    end
  end
end
