class AddColumnCurrentToCoursePackageUsers < ActiveRecord::Migration
  def self.up
    add_column :course_package_users, :current, :boolean, :default => false

    add_index :course_package_users, :current
  end

  def self.down
    remove_column :course_package_users, :current
  end
end
