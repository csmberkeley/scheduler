class AddAttendanceToSections < ActiveRecord::Migration
  def change
    add_column :sections, :password, :string
    add_column :sections, :pass_enabled, :boolean, :default => false
  end
end
