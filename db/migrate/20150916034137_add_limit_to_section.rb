class AddLimitToSection < ActiveRecord::Migration
  def change
    add_column :sections, :limit, :integer
  end
end
