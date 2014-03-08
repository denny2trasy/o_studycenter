class AddSessionIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :session_id, :string
  end

  def self.down
    remove_column :schedules, :session_id
  end
end
