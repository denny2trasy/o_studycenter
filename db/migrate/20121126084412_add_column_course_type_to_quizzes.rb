class AddColumnCourseTypeToQuizzes < ActiveRecord::Migration
  def self.up
    add_column :quizzes, :course_type, :string
    add_column :quizzes, :course_id, :integer
  end

  def self.down
    remove_column :quizzes, :course_id
    remove_column :quizzes, :course_type
  end
end
