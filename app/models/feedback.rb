class Feedback < ActiveRecord::Base
  belongs_to :activity
  belongs_to :recruit
  belongs_to :employee

  def scored?
    !score.nil?
  end

  def score_tier
    return nil unless scored?
    case score
    when -2..-1: :awful
    when -2...0: :bad
    when 0     : :neutral
    when 0..1  : :good
    when 1..2  : :awesome
    else :wtf
    end
  end

  %w[awesome good neutral bad awful].each do |tier|
    instance_eval do
      define_method("#{tier}?") do
        score_tier == tier.to_sym
      end
    end
  end
end
