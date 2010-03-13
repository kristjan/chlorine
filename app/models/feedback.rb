class Feedback < ActiveRecord::Base
  belongs_to :activity
  belongs_to :recruit
  belongs_to :employee
end
