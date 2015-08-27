class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :section_id
      t.integer :user_id
      t.text :body
      t.integer :enroll_id

      t.timestamps
    end
  end
end
