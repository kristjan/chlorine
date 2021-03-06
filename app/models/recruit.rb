class Recruit < ActiveRecord::Base
  has_many :feedbacks, :dependent => :destroy
  has_many :activities, :order => 'created_at', :dependent => :destroy
  has_many :documents, :dependent => :destroy

  has_one :employee

  validates_presence_of :name

  POSITIONS = [
    "Software Engineer",
    "Operations Engineer",
    "VP Engineering",
    "Designer"
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

  def self.to_employ
    hired = Activity::Hired.all.map(&:recruit_id)
    employed = Employee.all.map(&:recruit_id)
    Recruit.find(hired - employed).sort_by(&:name)
  end

  def important?
    current_activity.pipeline_stage == :new ||
    (current_activity.pipeline_stage == :in_process &&
     current_activity.stale?)
  end

  def promote!
    next_activity.create!(:recruit => self)
  end
  def hired?
    Activity::Hired.exists?(:recruit_id => self.id)
  end

  def demote!
    current_activity.destroy
    refresh_current_activity
    current_activity.update_attributes(:completed_at => nil)
  end

  def reject!
    return if rejected?
    Activity::Rejected.create!(
      :recruit => self,
      :completed_at => Time.now)
  end
  def rejected?
    Activity::Rejected.exists?(:recruit_id => self.id)
  end

  def decline!
    return if declined?
    Activity::Declined.create!(
      :recruit => self,
      :completed_at => Time.now)
  end
  def declined?
    Activity::Declined.exists?(:recruit_id => self.id)
  end

  def activity(name)
    activities.detect{|a| a.underscored_name == "activity_#{name.to_s}"}
  end

  def first_name
    name.split.first
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
    @current_activity ||= activities.last
  end
  def refresh_current_activity
    @current_activity = activities.last
  end

  def next_activity
    Activity.next(current_activity)
  end

  after_create do |recruit|
    Activity::New.create!(:recruit => recruit)
  end

  before_save do |recruit|
    recruit.phone.gsub!(/\D/, '') if recruit.phone
  end
end
