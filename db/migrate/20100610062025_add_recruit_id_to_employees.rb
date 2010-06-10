class AddRecruitIdToEmployees < ActiveRecord::Migration
  def self.up
    add_column :employees, :recruit_id, :integer
    add_index  :employees, :recruit_id
  end

  def self.down
    remove_index  :employees, :recruit_id
    remove_column :employees, :recruit_id
  end
end
