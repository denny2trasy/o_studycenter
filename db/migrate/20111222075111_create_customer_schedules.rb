class CreateCustomerSchedules < ActiveRecord::Migration
  def self.up
    create_table :customer_schedules do |t|
      t.integer :customer_id, :schedule_id

      t.timestamps
    end
  end

  def self.down
    drop_table :customer_schedules
  end
end
