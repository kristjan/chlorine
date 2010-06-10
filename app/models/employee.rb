class Employee < ActiveRecord::Base
  default_scope :order => :name

  has_many :employee_activities
  has_many :activities, :through => :employee_activities

  belongs_to :recruit

  def self.name_id_pairs
    Employee.all.map{|e| [e.name, e.id]}
  end

  def can_leave_feedback_for?(recruit)
    activity = recruit.current_activity
    return false unless activity.requires_feedback?
    return true if activity.has_all_feedback?
    return assigned_to?(activity)
  end

  def can_score?(activity)
    assigned_to?(activity) && !activity.received_score_from?(self)
  end

  def assigned_to?(activity)
    EmployeeActivity.exists?(:employee_id => self.id, :activity_id => activity.id)
  end
end
