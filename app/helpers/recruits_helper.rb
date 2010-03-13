module RecruitsHelper
  def schedule_text(activity)
    "Schedule " + activity.friendly_name
  end

  def advance_text(activity)
    "Move on to " + activity.friendly_name
  end

  def employees_for_select_options(employees=nil)
    employees ||= Employee.all
    employees.map{|e| [e.name, e.id]}
  end
end