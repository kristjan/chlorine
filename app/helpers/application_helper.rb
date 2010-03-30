# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
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
end
