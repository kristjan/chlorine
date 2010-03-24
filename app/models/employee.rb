class Employee < ActiveRecord::Base
  has_many :employee_activities
  has_many :activities, :through => :employee_activities

  def can_leave_feedback_for?(recruit)
    activity = recruit.current_activity
    return false unless activity.gets_feedback?
    return true if activity.initial_feedback_submitted?
    return assigned_to?(activity)
  end

  def assigned_to?(activity)
    EmployeeActivity.exists?(:employee_id => self.id, :activity_id => activity.id)
  end
end
