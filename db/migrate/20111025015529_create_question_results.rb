class CreateQuestionResults < ActiveRecord::Migration
  def self.up
    create_table :question_results do |t|
      t.integer :test_result_id,:user_id,:question_id,:answer_id
      t.string  :answer_name
      t.boolean :is_correct
      t.timestamps
    end
  end

  def self.down
    drop_table :question_results
  end
end
