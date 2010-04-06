class AddPositionToRecruits < ActiveRecord::Migration
  def self.up
    add_column :recruits, :position, :string
  end

  def self.down
    remove_column :recruits, :position
  end
end
