class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :feedback_id
      t.integer :question_id
      t.text :answer

      t.timestamps
    end
  end
end
