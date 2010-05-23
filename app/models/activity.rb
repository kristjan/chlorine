class Activity < ActiveRecord::Base
  belongs_to :recruit
  has_many :employee_activities, :dependent => :destroy
  has_many :employees, :through => :employee_activities
  has_many :feedbacks, :dependent => :destroy

  validates_presence_of :recruit
  validates_presence_of :scheduled_date, :if => :scheduled_hour
  validates_presence_of :scheduled_hour, :if => :scheduled_date

  def number_of_people_assigned
    if employee_ids_changed? && @employee_ids_to_save.any? && @employee_ids_to_save.size != employees_required
      errors.add(:employees, "are important, but you need to pick #{employees_required}")
    end
  end

  class New               < Activity; end
  class PhoneIntro        < Activity; end
  class PhoneScreen       < Activity; end
  class WhiteboardSession < Activity; end
  class CodingSession     < Activity; end
  class MeetTheBoss       < Activity; end
  class ReferenceCheck    < Activity; end
  class Offer             < Activity; end
  class Hired             < Activity; end
  class Rejected          < Activity; end
  class Declined          < Activity; end

  ACTIVITY_ORDER = [
    New,
    PhoneIntro,
    PhoneScreen,
    WhiteboardSession,
    CodingSession,
    MeetTheBoss,
    ReferenceCheck,
    Offer,
    Hired,
  ]

  ACTIVITIES = ACTIVITY_ORDER
  TERMINAL_ACTIVITIES    = [Hired, Rejected, Declined]
  NONTERMINAL_ACTIVITIES = ACTIVITY_ORDER - TERMINAL_ACTIVITIES
  SCHEDULABLE_ACTIVITIES = [PhoneIntro, PhoneScreen, WhiteboardSession,
                            CodingSession, MeetTheBoss]
  FEEDBACK_ACTIVITIES    = ACTIVITY_ORDER - TERMINAL_ACTIVITIES - [Offer]

  named_scope :in_process, :conditions => {
    :type => NONTERMINAL_ACTIVITIES.map(&:name),
    :completed_at => nil
  }

  def self.next(activity)
    return nil if activity.terminal?
    ACTIVITY_ORDER[ACTIVITY_ORDER.index(activity.class) + 1]
  end

  def self.previous(activity)
    return nil if activity.is_a?(New)
    ACTIVITY_ORDER[ACTIVITY_ORDER.index(activity.class) - 1]
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

  def current?
    self == recruit.current_activity
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

  def current?
    recruit.current_activity == self
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

  def requires_feedback?
    FEEDBACK_ACTIVITIES.include?(self.class)
  end

  def received_score_from?(employee)
    feedbacks.with_scores.from_employee(employee).exists?
  end

  def has_all_feedback?
    employees.any? && employees.map{|e| received_score_from?(e)}.all?
  end

  def ready_to_move_on?
    return false if needs_scheduling? && !scheduled?
    return false if requires_feedback? && !has_all_feedback?
    return true
  end

  def terminal?
    TERMINAL_ACTIVITIES.include?(self.class)
  end

  def feedback_activities_left
    index = FEEDBACK_ACTIVITIES.index(self.class)
    index ? FEEDBACK_ACTIVITIES[(index+1)..-1] : []
  end

  before_save do |activity|
    Rails.logger.info "Before save #{@employee_ids_to_save.inspect}"
    activity.reassign_employees if activity.employee_ids_changed?
  end

end
