module RecruitsHelper
  def schedule_text(activity)
    "Schedule " + activity.friendly_name
  end

  def advance_text(activity)
    "Move on to " + activity.friendly_name
  end

  def employee_option_tags
    Employee.all.map do |e|
      "<option value='#{e.id}'>#{e.name}</option>"
    end
  end
end
