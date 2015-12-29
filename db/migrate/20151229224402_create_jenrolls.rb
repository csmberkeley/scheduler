class CreateJenrolls < ActiveRecord::Migration
  def change
    create_table :jenrolls do |t|
      t.integer :user_id
      t.integer :course_id
      t.integer :section_id
      t.integer :senroll

      t.timestamps
    end
  end
end
