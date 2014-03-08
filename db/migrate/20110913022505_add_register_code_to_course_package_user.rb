class AddRegisterCodeToCoursePackageUser < ActiveRecord::Migration
  def self.up
    add_column  :course_package_users,  :register_code_id, :integer
    add_column  :course_package_users,  :register_code_code,  :string
  end

  def self.down
    remove_column :course_package_users,  :register_code_id
    remove_column :course_package_users,  :register_code_code
  end
end
