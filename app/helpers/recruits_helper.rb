module RecruitsHelper
  def schedule_text(activity)
    activity.scheduled? ? "Reschedule" : "Schedule"
  end

  def promote_text(activity)
     "Promote"
  end

  def demote_text(activity)
     "Demote"
  end

  def employees_assigned_to(action)
    names = action.employees.map(&:name).sort.
      map{|name| name == current_user.name ? content_tag(:strong, name) : name}.
      join(',')
    names.blank? ? '-' : names
  end

  def assigned_to_sort_data(activity)
    employees_assigned_to(activity).include?(current_user.name) ? 0 : 1
  end

  def employees_for_select_options(employees=nil)
    employees ||= Employee.all
    employees.map{|e| [e.name, e.id]}
  end

  def feedback_dot(feedback)
    link_to '', recruit_url(feedback.recruit,
                            :anchor => feedback_anchor(feedback)),
            :class => "dot #{feedback.score_tier}",
            :title => "#{feedback.employee.name} (#{feedback.score})",
            :onclick => "expandToFeedback(
                           #{feedback.activity_id}, '#{feedback_anchor(feedback)}');
                           return false;"

  end

  def feedback_anchor(feedback)
    "feedback_#{feedback.id}"
  end

  def feedback_meter(feedbacks)
    scores = feedbacks.map(&:score).compact
    return nil if scores.empty?
    mean = scores.inject(0) {|sum, i| sum + i} / scores.size
    scaled_mean = 50 + 25*mean
    chart_url = """
      http://chart.apis.google.com/chart?
        chs=80x40&cht=gom&chd=t:#{scaled_mean}&chf=bg,s,00000000&
        chco=FF0000,FF8000,FFFF00,80FF00,00FF00
    """.gsub(/\s/, '')
    image_tag chart_url, :title => mean.round(2)
  end

  def new_feedback(activity)
    Feedback.new(:activity => activity,
                 :recruit => activity.recruit,
                 :employee => current_user)
  end

  def lifeguard(activity)
    if activity.employees_required == 0 ||
      !activity.has_all_feedback?
      "The lifeguard is off duty."
    else
      "The lifeguard says: #{Feedback.rules_tier(activity.feedbacks)}"
    end
  end

  def positions_for_select
    Recruit::POSITIONS.map{|p| [p, p]}
  end

  def tab_id(activity)
    "tab_#{tab_name(activity)}"
  end

  def tab_partial(activity)
    "recruits/activity_tabs/#{tab_name(activity)}"
  end

  def assigned_employee_names(activity)
    activity.employees.map(&:name).join(', ')
  end
private

  def tab_name(activity)
    activity.underscored_name.sub('activity_', '')
  end

end
