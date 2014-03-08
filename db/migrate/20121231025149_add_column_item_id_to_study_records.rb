class AddColumnItemIdToStudyRecords < ActiveRecord::Migration
  def self.up
    add_column :study_records, :item_id, :integer
  end

  def self.down
    remove_column :study_records, :item_id
  end
end
