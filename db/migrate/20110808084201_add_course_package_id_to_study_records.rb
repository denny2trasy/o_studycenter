class AddCoursePackageIdToStudyRecords < ActiveRecord::Migration
  def self.up
    add_column :study_records, :course_package_id, :integer

  end

  def self.down
    remove_column :study_records, :course_package_id
  end
end
