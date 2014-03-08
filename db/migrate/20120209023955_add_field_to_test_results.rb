class AddFieldToTestResults < ActiveRecord::Migration
  def self.up
    add_column  :test_results,  :skill_name,  :string  
    add_column  :test_results,  :skill_level, :integer
    add_column  :test_results,  :skill_score, :integer
    
    add_column  :question_results,  :evaluation_activity_id,  :integer
    
    add_index :question_results, [:test_result_id,:evaluation_activity_id], :name => "by_test_and_skill"
  end

  def self.down
    remove_column :test_results,  :skill_name
    remove_column :test_results,  :skill_level
    remove_column :test_results,  :skill_score
    
    remove_column :question_results,  :evaluation_activity_id
    
    remove_index :question_results, :name => "by_test_and_skill"
  end
end
