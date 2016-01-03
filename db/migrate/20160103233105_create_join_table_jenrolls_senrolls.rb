class CreateJoinTableJenrollsSenrolls < ActiveRecord::Migration
  def change
    create_join_table :jenrolls, :senrolls do |t|
      # t.index [:jenroll_id, :senroll_id]
      # t.index [:senroll_id, :jenroll_id]
    end
  end
end
