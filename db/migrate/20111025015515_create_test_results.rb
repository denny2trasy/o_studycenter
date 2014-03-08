class CreateTestResults < ActiveRecord::Migration
  def self.up
    create_table :test_results do |t|
      t.integer :user_id,:level
      t.decimal  :score, :precision => 6, :scale => 3
      t.timestamps
    end
  end

  def self.down
    drop_table :test_results
  end
end
