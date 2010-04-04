class Feedback < ActiveRecord::Base
  belongs_to :activity
  belongs_to :recruit
  belongs_to :employee

  def scored?
    !score.nil?
  end

  def good?
    scored? && score > 0
  end

  def awesome?
    scored? && score >= 1
  end

  def bad?
    scored? && score < 0
  end

  def awful?
    scored? && score <= -1
  end
end
