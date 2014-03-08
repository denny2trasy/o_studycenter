class RenameSubmitAnswerNameColumn < ActiveRecord::Migration
  def self.up
    rename_column :examination_quizzes, :submit_answer_name, :submit_answer
  end

  def self.down
    rename_column :examination_quizzes, :submit_answer, :submit_answer_name
  end
end
