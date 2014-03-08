class CreateSubQuizzes < ActiveRecord::Migration
  def self.up
    create_table :sub_quizzes do |t|
      t.integer :quiz_id
      t.string :title
      t.integer :order_in_quiz

      t.timestamps
    end
  end

  def self.down
    drop_table :sub_quizzes
  end
end
