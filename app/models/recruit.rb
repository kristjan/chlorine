class Recruit < ActiveRecord::Base
  has_many :feedbacks
  has_many :activities, :order => 'created_at'
  has_many :documents

  POSITIONS = [
    "Kode Koala",
    "Ops Ostrich"
  ]

  def self.by_action_needed
    activities = Activity.in_process.all
    recruits = activities.map(&:recruit).uniq
    by_state = recruits.group_by do |recruit|
      activity = recruit.current_activity
      result = :confused
      if activity.scheduled?
        result = :decision   if  activity.scheduled_time.past?
        result = :upcoming   if  activity.scheduled_time.future?
      else
        result = :scheduling
      end
      result
    end

    [:decision, :upcoming, :scheduling, :confused].each do |state|
      by_state[state] ||= []
    end

    by_state[:decision] =
      by_state[:decision].sort_by {|recruit| recruit.current_activity.scheduled_time}
    by_state[:upcoming] =
      by_state[:upcoming].sort_by {|recruit| recruit.current_activity.scheduled_time}
    by_state[:scheduling] =
      by_state[:scheduling].sort_by {|recruit| recruit.current_activity.created_at}

    by_state
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
    recruit.phone.gsub!(/\D/, '') if recruit.phone
  end
end
