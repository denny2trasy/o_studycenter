class AddFieldToQuestions < ActiveRecord::Migration
  def self.up
    add_column  :questions, :instruction, :string
    add_column  :questions, :evaluation_activity_id,  :integer   # this is for skill id
  end

  def self.down
    remove_column :questions, :instruction
    remove_column :questions, :evaluation_activity_id
  end
end
