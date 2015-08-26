class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :setting_name
      t.boolean :enabled

      t.timestamps
    end
  end
end
