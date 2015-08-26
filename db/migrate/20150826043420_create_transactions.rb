class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.integer :enroll_id
      t.string :body
      t.timestamps
    end
  end
end
