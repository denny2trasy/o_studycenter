class AddImagesToSubQuizzes < ActiveRecord::Migration
  def self.up
    add_column :sub_quizzes, :images, :string
    add_column :sub_quizzes, :sounds, :string
  end

  def self.down
    remove_column :sub_quizzes, :sounds
    remove_column :sub_quizzes, :images
  end
end
