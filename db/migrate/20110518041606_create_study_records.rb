class CreateStudyRecords < ActiveRecord::Migration
  def self.up
    create_table :study_records do |t|
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end

    add_index :study_records, :user_id
    add_index :study_records, :lesson_id
  end

  def self.down
    drop_table :study_records
  end
end
