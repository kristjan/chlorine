class Recruit < ActiveRecord::Base
  has_many :feedbacks
  has_many :activities, :order => 'created_at'
  has_many :documents

  def status
    if current_activity.terminal?
      current_activity.friendly_name
    elsif current_activity.scheduled?
      current_activity.friendly_name
    elsif current_activity.needs_scheduling?
      "Scheduling " + current_activity.friendly_name
    else
      current_activity.friendly_name
    end
  end

  def current_activity
    @current_activity ||= activities.last(:order => :created_at)
  end

  def next_activity
    Activity.next(current_activity)
  end

  after_create do |recruit|
    Activity::Received.create!(:recruit => recruit, :scheduled_for => Time.now.utc)
  end

  before_save do |recruit|
    recruit.phone.gsub!(/\D/, '')
  end
end
