class AddColumnCourseIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :course_id, :integer
    add_column :schedules, :course_type, :string
  end

  def self.down
    remove_column :schedules, :course_type
    remove_column :schedules, :course_id
  end
end
