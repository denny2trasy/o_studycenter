class CreateOenglishes < ActiveRecord::Migration
  def self.up
    create_table :oenglishes do |t|
      t.string  :name
      t.string  :video_url
      t.string  :show_oenglish_id
      t.string  :description
      t.timestamps
    end
  end

  def self.down
    drop_table :oenglishes
  end
end
