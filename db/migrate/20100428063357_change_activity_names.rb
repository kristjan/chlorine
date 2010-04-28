class ChangeActivityNames < ActiveRecord::Migration
  def self.up
    execute <<-SQL
      UPDATE activities
      SET type="Activity::New"
      WHERE type="Activity::Received"
    SQL
    execute <<-SQL
      UPDATE activities
      SET type="Activity::MeetTheBoss"
      WHERE type="Activity::TalkToJoe"
    SQL
  end

  def self.down
    execute <<-SQL
      UPDATE activities
      SET type="Activity::Received"
      WHERE type="Activity::New"
    SQL
    execute <<-SQL
      UPDATE activities
      SET type="Activity::TalkToJoe"
      WHERE type="Activity::MeetTheBoss"
    SQL
  end
end
