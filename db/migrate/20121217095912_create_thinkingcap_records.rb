class CreateThinkingcapRecords < ActiveRecord::Migration
  def self.up
    create_table :thinkingcap_records do |t|
      t.integer :user_id, :third_content_id
      t.string  :thinkingcap_course_id
      t.decimal :score, :progress, :precision => 5, :scale => 1
      t.decimal :duration,  :precision => 10, :scale => 1
      t.timestamps
    end
  end

  def self.down
    drop_table :thinkingcap_records
  end
end
