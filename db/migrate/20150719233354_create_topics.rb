class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.integer :course_id
      t.string :name

      t.timestamps
    end
  end
end
