class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :name
      t.datetime :start
      t.datetime :end
      t.boolean :empty

      t.timestamps
    end
  end
end
