class AddItemGroupIdToExaminations < ActiveRecord::Migration
  def self.up
    add_column :examinations, :item_group_id, :integer
  end

  def self.down
    remove_column :examinations, :item_group_id
  end
end
