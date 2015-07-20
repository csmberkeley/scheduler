class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :session_id
      t.boolean :completed

      t.timestamps
    end
  end
end
