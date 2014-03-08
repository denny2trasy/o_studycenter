class CreateExaminations < ActiveRecord::Migration
  def self.up
    create_table :examinations do |t|
      t.string :title
      t.integer :user_id
      t.integer :lesson_id
      t.integer :level
      t.decimal :score

      t.timestamps
    end
  end

  def self.down
    drop_table :examinations
  end
end
