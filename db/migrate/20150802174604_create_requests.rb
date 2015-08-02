class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :section_id
      t.integer :user_id
      t.integer :priority

      t.timestamps
    end
  end
end
