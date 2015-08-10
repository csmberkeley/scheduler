class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.integer :section_id
      t.integer :user_id
      t.string :status
      t.text :body

      t.timestamps
    end
  end
end
