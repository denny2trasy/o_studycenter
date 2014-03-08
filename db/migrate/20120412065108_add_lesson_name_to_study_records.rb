class AddLessonNameToStudyRecords < ActiveRecord::Migration
  def self.up
    add_column :study_records, :lesson_name, :string
  end

  def self.down
    remove_column :study_records, :lesson_name
  end
end
