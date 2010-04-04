class Activity < ActiveRecord::Base
  belongs_to :recruit
  has_many :employee_activities
  has_many :employees, :through => :employee_activities
  has_many :feedbacks

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

  TERMINAL_ACTIVITIES    = [Hired, Rejected, Declined]
  SCHEDULABLE_ACTIVITIES = [PhoneIntro, PhoneScreen, WhiteboardSession,
                            CodingSession, TalkToJoe]
  FEEDBACK_ACTIVITIES    = [PhoneScreen, WhiteboardSession, CodingSession, ReferenceCheck]

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

  def self.underscored_name
    self.name.underscore.gsub('/','_')
  end
  def underscored_name
    self.class.underscored_name
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

  def assign!(employee)
    employee = Employee.find(employee) if employee.is_a?(Fixnum)
    employees << employee
  end

  def unassign!(employee)
    employee = Employee.find(employee) if employee.is_a?(Fixnum)
    employees.delete employee
  end

  def scheduled_time
    (scheduled_date + scheduled_hour.hours).utc if scheduled_date && scheduled_hour
  end

  def employee_ids
    employees.map(&:id)
  end

  def employee_ids=(ids)
    ids = ids.map(&:to_i)
    to_create = ids - employee_ids
    to_delete = employee_ids - ids
    to_create.each {|id| assign!(id)   }
    to_delete.each {|id| unassign!(id) }
  end

  def finish!
    update_attributes!(:completed_at => Time.now)
  end

  def scheduled?
    !scheduled_time.nil?
  end

  def needs_scheduling?
    SCHEDULABLE_ACTIVITIES.include?(self.class)
  end

  def gets_feedback?
    FEEDBACK_ACTIVITIES.include?(self.class)
  end

  def initial_feedback_submitted?
    feedbacks.any? && employees.map(&:id) == feedbacks.map(&:employee_id).uniq
  end

  def terminal?
    TERMINAL_ACTIVITIES.include?(self.class)
  end

end
