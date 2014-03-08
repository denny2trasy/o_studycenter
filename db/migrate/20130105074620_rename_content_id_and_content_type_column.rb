class RenameContentIdAndContentTypeColumn < ActiveRecord::Migration
  def self.up
    rename_column :schedules, :course_id, :content_id
    rename_column :schedules, :course_type, :content_type
  end

  def self.down
    rename_column :schedules, :content_id, :course_id
    rename_column :schedules, :content_type, :course_type
  end
end
