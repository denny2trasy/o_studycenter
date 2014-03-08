class CreateExaminationQuizzes < ActiveRecord::Migration
  def self.up
    create_table :examination_quizzes do |t|
      t.string :title
      t.integer :user_id
      t.integer :examination_id
      t.integer :quiz_id
      t.string :quiz_type
      t.integer :submit_answer_id
      t.string :submit_answer_name
      t.boolean :is_correct
      t.integer :level_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :examination_quizzes
  end
end
