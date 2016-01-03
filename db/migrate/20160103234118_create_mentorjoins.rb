class CreateMentorjoins < ActiveRecord::Migration
  def change
    create_table :mentorjoins do |t|
      t.integer :jenroll_id
      t.integer :senroll_id
      t.string :location
      t.string :time

      t.timestamps
    end
  end
end
