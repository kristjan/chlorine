class Recruit < ActiveRecord::Base
  has_many :feedbacks
  has_many :activities, :order => 'created_at'
  has_many :documents

  def self.in_process
    activities = Activity.in_process.all
    activities.map(&:recruit).uniq.partition do |recruit|
      !recruit.current_activity.scheduled?
    end.map do |recruits|
      recruits.sort_by do |recruit|
        recruit.current_activity.scheduled? ?
          recruit.current_activity.scheduled_time :
          recruit.current_activity.updated_at
      end
    end.flatten
  end

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
    Activity::Received.create!(:recruit => recruit)
  end

  before_save do |recruit|
    recruit.phone.gsub!(/\D/, '')
  end
end
