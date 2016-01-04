class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :enroll_id
      t.integer :status
      t.string :reason
      t.integer :week
      t.integer :senroll_id
      t.integer :jenroll_id

      t.timestamps
    end
  end
end
