class AddDescriptionToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :description, :text
  end

  def self.down
    remove_column :schedules, :description
  end
end
