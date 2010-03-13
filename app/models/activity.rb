class Activity < ActiveRecord::Base
  belongs_to :recruit
  has_many :employee_activities
  has_many :employees, :through => :employee_activities

  class Received          < Activity; end
  class PhoneIntro        < Activity; end
  class PhoneScreen       < Activity; end
  class WhiteboardSession < Activity; end
  class CodingSession     < Activity; end
  class TalkToJoe         < Activity; end
  class ReferenceCheck    < Activity; end
  class Offer             < Activity; end
  class Hired             < Activity; end
  class Rejected          < Activity; end
  class Declined          < Activity; end

  ACTIVITY_ORDER = [
    Received,
    PhoneIntro,
    PhoneScreen,
    WhiteboardSession,
    CodingSession,
    TalkToJoe,
    ReferenceCheck,
    Offer,
    Hired,
  ]

  TERMINAL_ACTIVITIES = [Hired, Rejected, Declined]

  def self.next(activity)
    return nil if activity.terminal?
    puts "ACTIVITY: " + activity.inspect
    ACTIVITY_ORDER[ACTIVITY_ORDER.index(activity.class) + 1]
  end

  def self.friendly_name
    self.name.split("::").last.underscore.titleize
  end
  def friendly_name
    self.class.friendly_name
  end

  def self.name_for_params
    self.name.underscore
  end
  def name_for_params
    self.class.name_for_params
  end

  def self.from_param(param)
    subclasses.select {|klass| klass.name_for_params == param}.first
  end

  def finish!
    update_attributes!(:completed_at => Time.now)
  end

  def scheduled?
    !scheduled_for.nil?
  end

  def terminal?
    TERMINAL_ACTIVITIES.include?(self.class)
  end

end
