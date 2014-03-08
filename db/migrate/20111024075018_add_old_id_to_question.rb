class AddOldIdToQuestion < ActiveRecord::Migration
  def self.up
    add_column  :questions, :old_id,  :integer
  end

  def self.down
    remove_column :questions, :old_id
  end
end
