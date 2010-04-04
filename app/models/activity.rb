class Activity < ActiveRecord::Base
  belongs_to :recruit
  has_many :employee_activities
  has_many :employees, :through => :employee_activities
  has_many :feedbacks

  validates_presence_of :recruit
  validates_presence_of :scheduled_date, :if => :scheduled_hour
  validates_presence_of :scheduled_hour, :if => :scheduled_date

  validate :time_is_in_the_future
  validate :number_of_people_assigned

  def time_is_in_the_future
    if scheduled_time && scheduled_time_changed? && scheduled_time.past?
      errors.add(:scheduled_time,
                 "must be in the future unless you're Arnold Schwarzenegger")
    end
  end

  def number_of_people_assigned
    if employee_ids_changed? && @employee_ids_to_save.any? && @employee_ids_to_save.size != employees_required
      errors.add(:employees, "are important, but you need to pick #{employees_required}")
    end
  end

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
  NONTERMINAL_ACTIVITIES = ACTIVITY_ORDER - TERMINAL_ACTIVITIES
  SCHEDULABLE_ACTIVITIES = [PhoneIntro, PhoneScreen, WhiteboardSession,
                            CodingSession, TalkToJoe]
  FEEDBACK_ACTIVITIES    = [PhoneScreen, WhiteboardSession, CodingSession, ReferenceCheck]

  named_scope :in_process, :conditions => {
    :type => NONTERMINAL_ACTIVITIES.map(&:name),
    :completed_at => nil
  }

  def self.next(activity)
    return nil if activity.terminal?
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

  def scheduled_time_changed?
    scheduled_date_changed? || scheduled_hour_changed?
  end

  def employee_ids
    employees.map(&:id)
  end

  def employee_ids=(ids)
    Rails.logger.info "Setting employee ids to #{ids}"
    @employee_ids_to_save = ids.map(&:to_i)
  end

  def employee_ids_changed?
    @employee_ids_to_save && @employee_ids_to_save.sort != employee_ids.sort
  end

  def reassign_employees
    Rails.logger.info "Saving employees"
    to_create = @employee_ids_to_save - employee_ids
    to_delete = employee_ids - @employee_ids_to_save
    to_create.each {|id| assign!(id)   }
    to_delete.each {|id| unassign!(id) }
  end

  def employees_required
    return 0 unless needs_scheduling?
    self.is_a?(WhiteboardSession) ? 4 : 1
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

  def has_all_feedback?
    feedbacks.any? && employees.map(&:id) == feedbacks.map(&:employee_id).uniq
  end

  def ready_to_move_on?
    return false if needs_scheduling? && !scheduled?
    return false if gets_feedback? && !has_all_feedback?
    return true
  end

  def terminal?
    TERMINAL_ACTIVITIES.include?(self.class)
  end

  before_save do |activity|
    Rails.logger.info "Before save #{@employee_ids_to_save.inspect}"
    activity.reassign_employees if activity.employee_ids_changed?
  end

end
