class AddColumnVariaContentToMailRecords < ActiveRecord::Migration
  def self.up
    add_column :mail_records, :varia_content, :text
  end

  def self.down
    remove_column :mail_records, :varia_content
  end
end
