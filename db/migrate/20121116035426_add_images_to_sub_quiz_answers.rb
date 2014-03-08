class AddImagesToSubQuizAnswers < ActiveRecord::Migration
  def self.up
    add_column :sub_quiz_answers, :images, :string
    add_column :sub_quiz_answers, :sounds, :string
  end

  def self.down
    remove_column :sub_quiz_answers, :sounds
    remove_column :sub_quiz_answers, :images
  end
end
