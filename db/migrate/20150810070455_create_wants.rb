class CreateWants < ActiveRecord::Migration
  def change
    create_table :wants do |t|
      t.integer :offer_id
      t.integer :section_id

      t.timestamps
    end
  end
end
