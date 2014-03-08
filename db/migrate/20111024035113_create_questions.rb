class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.string  :prompt,:sounds,:instruction_sounds
      t.integer :ordering,:level_id
      t.integer :exposure,:bank
      t.decimal :logit, :precision => 6, :scale => 3
      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
