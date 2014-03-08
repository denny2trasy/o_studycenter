class CreateEnrollWebexes < ActiveRecord::Migration
  def self.up
    create_table :enroll_webexes do |t|
      t.string :enroll_id
      t.integer :schedule_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :enroll_webexes
  end
end
