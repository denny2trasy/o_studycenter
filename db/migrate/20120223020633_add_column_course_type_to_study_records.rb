class AddColumnCourseTypeToStudyRecords < ActiveRecord::Migration
  def self.up
    add_column :study_records, :course_type, :string
  end

  def self.down
    remove_column :study_records, :course_type
  end
end
