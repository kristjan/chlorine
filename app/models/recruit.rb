class Recruit < ActiveRecord::Base
  has_many :feedbacks
  has_many :activities

  def status
    "Pending"
  end

  def current_activity
    activities.last(:order => :created_at)
  end

  after_create do |recruit|
    Activity.received!(recruit)
  end
end
