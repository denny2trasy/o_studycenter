class AddSlideIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :slide_id, :integer
  end

  def self.down
    remove_column :schedules, :slide_id
  end
end
