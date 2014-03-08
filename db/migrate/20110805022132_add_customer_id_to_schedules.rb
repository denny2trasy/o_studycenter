class AddCustomerIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :customer_id, :integer
  end

  def self.down
    remove_column :schedules, :customer_id
  end
end
