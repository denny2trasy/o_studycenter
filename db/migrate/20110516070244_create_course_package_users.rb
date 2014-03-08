class CreateCoursePackageUsers < ActiveRecord::Migration
  def self.up
    create_table :course_package_users do |t|
      t.integer :course_package_id
      t.integer :user_id

      t.timestamps
    end

    add_index :course_package_users, :user_id
    add_index :course_package_users, :course_package_id
  end

  def self.down
    drop_table :course_package_users
  end
end
