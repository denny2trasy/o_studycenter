class AddImagesToQuizzes < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :images, :string
  end

  def self.down
    remove_column :quizzes, :images
  end
end
