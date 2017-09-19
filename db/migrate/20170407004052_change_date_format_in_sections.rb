class ChangeDateFormatInSections < ActiveRecord::Migration
  def up
    change_column :sections, :start, :datetime
    change_column :sections, :end, :datetime
  end

  def down
    change_column :sections, :start, :time
    change_column :sections, :end, :time
  end
end
