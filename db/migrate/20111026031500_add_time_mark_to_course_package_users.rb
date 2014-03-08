class AddTimeMarkToCoursePackageUsers < ActiveRecord::Migration
  def self.up
    add_column :course_package_users,  :activated_at,  :datetime
    add_column :course_package_users,  :expired_at,   :datetime
  end

  def self.down
    remove_column :course_package_users,  :activated_at
    remove_column :course_package_users,  :expired_at
  end
end
