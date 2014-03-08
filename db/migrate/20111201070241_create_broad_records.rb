class CreateBroadRecords < ActiveRecord::Migration
  def self.up
    create_table :broad_records do |t|
      t.integer :user_id,   :schedule_id
      t.datetime  :started_at,  :completed_at
      t.column  :times,   :integer, :default => 1
      t.timestamps
    end
    add_index :broad_records, :user_id
    add_index :broad_records, :schedule_id
  end

  def self.down
    drop_table :broad_records
  end
end
