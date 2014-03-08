class CreateWebexRecords < ActiveRecord::Migration
  def self.up
    create_table :webex_records do |t|
      t.integer  :user_id, :schedule_id
      t.datetime  :join_at, :leave_at,:register_at
      t.decimal   :duration,   :attention_radio_1, :attention_radio_2, :precision => 5, :scale => 1
      t.string    :ip_address,  :client_agent
      t.timestamps
    end
  end

  def self.down
    drop_table :webex_records
  end
end
