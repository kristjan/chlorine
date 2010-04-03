module RecruitsHelper
  def schedule_text(activity)
    "Schedule " + activity.friendly_name
  end

  def advance_text(activity)
    "&uarr; " + activity.friendly_name + " &uarr;"
  end

  def employees_for_select_options(employees=nil)
    employees ||= Employee.all
    employees.map{|e| [e.name, e.id]}
  end
end
