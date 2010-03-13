class CreateEmployeeActivities < ActiveRecord::Migration
  def self.up
    create_table :employee_activities do |t|
      t.integer :activity_id
      t.integer :employee_id
    end
  end

  def self.down
    drop_table :employee_activities
  end
end
