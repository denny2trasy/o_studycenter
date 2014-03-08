class CreateSubQuizAnswers < ActiveRecord::Migration
  def self.up
    create_table :sub_quiz_answers do |t|
      t.integer :sub_quiz_id
      t.string :title
      t.boolean :is_correct

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_quiz_answers
  end
end
