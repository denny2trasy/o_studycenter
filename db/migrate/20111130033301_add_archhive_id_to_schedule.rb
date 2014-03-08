class AddArchhiveIdToSchedule < ActiveRecord::Migration
  def self.up
    add_column  :schedules, :archive_id,  :string
  end

  def self.down
    remove_column :schedules, :archive_id
  end
end
