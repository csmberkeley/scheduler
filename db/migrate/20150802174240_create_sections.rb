class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.boolean :empty
      t.integer :course_id

      t.timestamps
    end
  end
end
