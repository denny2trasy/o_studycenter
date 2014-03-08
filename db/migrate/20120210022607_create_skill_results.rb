class CreateSkillResults < ActiveRecord::Migration
  def self.up
    create_table :skill_results do |t|
      t.column  :evaluation_activity_id,  :integer   # 214--vocabulary 215--grammar 216--listening
      t.column  :level, :integer
      t.column  :score, :integer
      t.column  :test_result_id,  :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :skill_results
  end
end
