class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :session_id
      t.integer :from_id
      t.text :body

      t.timestamps
    end
  end
end
