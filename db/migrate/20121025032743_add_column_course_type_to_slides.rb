class AddColumnCourseTypeToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :course_type, :string
  end

  def self.down
    remove_column :slides, :course_type
  end
end
