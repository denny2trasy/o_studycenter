class AddColumnLessonIdToSlides < ActiveRecord::Migration
  def self.up
    add_column :slides, :lesson_id, :integer
    add_column :slides, :download, :boolean
  end

  def self.down
    remove_column :slides, :download
    remove_column :slides, :lesson_id
  end
end
