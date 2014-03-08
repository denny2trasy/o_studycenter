class AddMsgTypeAndScheduleIdIntoMessages < ActiveRecord::Migration
  def self.up
    add_column :messages, :schedule_id, :integer
    add_column :messages, :msg_type, :boolean
  end

  def self.down
    remove_column :messages, :schedule_id
    remove_column :messages, :msg_type
  end
end
