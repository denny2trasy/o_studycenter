class AddCourseEndAtToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :course_end_at, :datetime
  end

  def self.down
    remove_column :schedules, :course_end_at
  end
end
