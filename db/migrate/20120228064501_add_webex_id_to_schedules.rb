class AddWebexIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :webex_id, :string
  end

  def self.down
    remove_column :schedules, :webex_id
  end
end
