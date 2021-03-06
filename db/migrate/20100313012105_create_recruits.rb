class CreateRecruits < ActiveRecord::Migration
  def self.up
    create_table :recruits do |t|
      t.string :name
      t.string :email
      t.string :phone
      t.string :referrer
      t.text   :how_found

      t.timestamps
    end
  end

  def self.down
    drop_table :recruits
  end
end
