module RecruitsHelper
  def schedule_text(activity)
    activity.scheduled? ? "Reschedule" : "Schedule"
  end

  def advance_text(activity)
    "&uarr; " + activity.friendly_name + " &uarr;"
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
    mean = scores.inject(0) {|sum, i| sum + i} / scores.size
    scaled_mean = 50 + 25*mean
    chart_url = """
      http://chart.apis.google.com/chart?
        chs=80x40&cht=gom&chd=t:#{scaled_mean}&chf=bg,s,00000000&
        chco=FF0000,FF8000,FFFF00,80FF00,00FF00
    """.gsub(/\s/, '')
    image_tag chart_url, :title => mean.round(2)
  end
end
