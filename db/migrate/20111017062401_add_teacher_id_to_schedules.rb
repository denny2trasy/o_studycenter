class AddTeacherIdToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules,  :teacher_id, :integer
  end

  def self.down
    remove_column :schedules, :teacher_id  
    
  end
end
