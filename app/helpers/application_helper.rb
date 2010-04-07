# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def brize(s)
    s.gsub("\n", "<br />")
  end

  def hours_for_select
    [
      ["7am",  7],
      ["8am",  8],
      ["9am",  9],
      ["10am", 10],
      ["11am", 11],
      ["Noon", 12],
      ["1pm",  13],
      ["2pm",  14],
      ["3pm",  15],
      ["4pm",  16],
      ["5pm",  17],
      ["6pm",  18],
      ["7pm",  19]
    ]
  end

  def facebook_profile_url(employee)
    "http://facebook.com/profile.php?id=#{employee.facebook_uid}"
  end

  def format_time(time)
    time.getlocal.strftime("%B %d, %I:%M%p") rescue '&mdash;'
  end

  def formatted_errors(errors)
    errors.full_messages.map {|m| "#{m}."}.join("<br />")
  end

  def link_to_facebook(employee)
    link_to employee.facebook_uid, facebook_profile_url(employee),
            :target => '_blank'
  end

  def phone(number, opts={})
    number_to_phone(number,
      opts.reverse_merge(:delimiter => '.'))
  end
end
