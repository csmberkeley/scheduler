class AddMentorEmailToSection < ActiveRecord::Migration
  def change
    add_column :sections, :mentor_email, :string
  end
end
