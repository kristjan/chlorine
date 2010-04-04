class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string    :type
      t.integer   :recruit_id
      t.date      :scheduled_date
      t.integer   :scheduled_hour
      t.timestamp :completed_at
      t.integer   :creator_id

      t.timestamps
    end
  end

  def self.down
    drop_table :activities
  end
end
