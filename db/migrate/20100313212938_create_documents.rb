class CreateDocuments < ActiveRecord::Migration
  def self.up
    create_table :documents do |t|
      t.string :filename
      t.integer :size
      t.string :content_type
      t.integer :recruit_id
      t.integer :db_file_id

      t.timestamps
    end
  end

  def self.down
    drop_table :documents
  end
end
