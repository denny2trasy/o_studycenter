class CreateMailRecords < ActiveRecord::Migration
  def self.up
    create_table :mail_records do |t|
      t.string :from
      t.string :to
      t.text :mail
      t.integer :mail_id
      t.boolean :status
      t.string :title
      t.string :error_message
      t.integer :mail_template_id
      t.datetime :sent_at

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_records
  end
end
