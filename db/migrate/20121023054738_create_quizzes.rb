class CreateQuizzes < ActiveRecord::Migration
  def self.up
    create_table :quizzes do |t|
      t.string :prompt
      t.string :sounds
      t.integer :position
      t.integer :level
      t.string :q_type

      t.timestamps
    end
  end

  def self.down
    drop_table :quizzes
  end
end
