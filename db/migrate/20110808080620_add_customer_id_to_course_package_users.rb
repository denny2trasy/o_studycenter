class AddCustomerIdToCoursePackageUsers < ActiveRecord::Migration
  def self.up
      add_column :course_package_users, :customer_id, :integer
  end

  def self.down
      remove_column :course_package_users, :customer_id
  end
end
