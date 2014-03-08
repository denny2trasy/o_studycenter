class AddWebexPwdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :webex_pwd, :string
  end

  def self.down
    remove_column :schedules, :webex_pwd
  end
end
