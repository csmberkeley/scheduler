class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.time :start
      t.time :end
      t.string :date
      t.boolean :empty
      t.integer :course_id
      t.string :location

      t.timestamps
    end
  end
end
