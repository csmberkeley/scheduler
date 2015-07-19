class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.integer :tutor_id
      t.integer :tutee_id
      t.text :availability
      t.text :additional_info
      t.datetime :start
      t.datetime :end
      t.string :status
      t.boolean :feedback

      t.timestamps
    end
  end
end
