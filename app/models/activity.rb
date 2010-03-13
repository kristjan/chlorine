class Activity < ActiveRecord::Base
  belongs_to :recruit
  has_many :employee_activities
  has_many :employees, :through => :employee_activities

  class Received          < Activity; end
  class PhoneIntro        < Activity; end
  class PhoneScreen       < Activity; end
  class WhiteboardSession < Activity; end
  class CodingSession     < Activity; end
  class TalkToJoe         < Activity; end
  class ReferenceCheck    < Activity; end
  class Offer             < Activity; end
  class Hired             < Activity; end
  class Rejected          < Activity; end
  class Declined          < Activity; end

  def self.received!(recruit)
    Activity::Received.create!(:recruit => recruit)
  end
end
