class RenameCourseTimeColumn < ActiveRecord::Migration
  def self.up
    rename_column :schedules, :course_time, :course_start_at
  end

  def self.down
    rename_column :schedules, :course_start_at, :course_time
  end
end
