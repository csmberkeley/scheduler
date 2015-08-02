class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.integer :section_d
      t.integer :user_id

      t.timestamps
    end
  end
end
