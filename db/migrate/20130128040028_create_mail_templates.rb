class CreateMailTemplates < ActiveRecord::Migration
  def self.up
    create_table :mail_templates do |t|
      t.string :name
      t.string :variables
      t.string :description
      t.text :content
      t.boolean :in_use
      t.string :used_by

      t.timestamps
    end
  end

  def self.down
    drop_table :mail_templates
  end
end
