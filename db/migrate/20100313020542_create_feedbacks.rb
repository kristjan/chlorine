class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :employee_id
      t.integer :recruit_id
      t.integer :activity_id
      t.text :body
      t.float :score

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end
