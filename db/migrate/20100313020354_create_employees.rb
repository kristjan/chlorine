class CreateEmployees < ActiveRecord::Migration
  def self.up
    create_table :employees do |t|
      t.string :name
      t.string :email
      t.integer :facebook_uid
      t.string :facebook_session

      t.timestamps
    end
  end

  def self.down
    drop_table :employees
  end
end
