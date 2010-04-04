class Feedback < ActiveRecord::Base
  belongs_to :activity
  belongs_to :recruit
  belongs_to :employee

  TIERS = [:awful, :bad, :neutral, :good, :awesome]

  validates_presence_of :body, :activity, :recruit, :employee
  validates_numericality_of :score, :allow_nil => true,
    :greater_than_or_equal_to => -2, :less_than_or_equal_to => 2

  named_scope :with_scores, :conditions => "score is not null"

  def self.tier_for(score)
    case score
    when -2..-1: :awful
    when -1...0: :bad
    when 0     : :neutral
    when 0...1 : :good
    when 1..2  : :awesome
    else
      case
      when score < -2: :awful
      when score >  2: :awesome
      else :wtf
      end
    end
  end

  def self.normalize(score)
    case
    when score <= -1: -4
    when score >=  1:  2
    when score <   0: -2
    when score >   0:  1
    else 0
    end
  end

  def self.overall_tier(feedbacks)
    rules_tier(feedbacks)
  end

  def self.mathematical_teir(feedbacks)
    weighted_scores = feedbacks.map do |feedback|
      score = feedback.score
      score < 0 ? score * 2 : score
    end
    tier = tier_for(weighted_scores.sum)
    tier == :wtf ? :awful : tier
  end

  def self.rules_tier(feedbacks)
    by_tier = feedbacks.group_by(&:score_tier)
    TIERS.each {|tier| by_tier[tier] ||= [] }


    if by_tier[:awful].any?
      # Two strong no votes cannot be overridden
      return :awful if by_tier[:awful].size > 1
      # One strong no can be overriden by two strong yesses
      return :awful unless by_tier[:awesome].size > 1
      return :neutral if (by_tier[:bad] + by_tier[:neutral]).any?
      return :good
    end
    # It takes one strong yes to override one weak no
    return :bad unless by_tier[:awesome].size   >= by_tier[:bad].size
    # We need at least one strong yes
    return :neutral unless by_tier[:awesome].any?
    return :awesome if by_tier[:bad].empty?
    return :good
  end

  def self.sniper_tier(feedbacks)
    scores = feedbacks.map(&:score_tier).compact.reject {|tier| tier == :neutral}
    partitioned = scores.partition {|score| [:good, :awesome].include?(score)}
    puts partitioned.inspect
    cops, robbers = partitioned[0], partitioned[1]

    cop_score = cops.map{|tier| tier == :awesome ? 2 : 0.99}.sum
    robber_score = robbers.map{|tier| tier == :bad ? 2 : 4}.sum

    total = cop_score - robber_score
    tier = tier_for(total)
    returning(tier) {|tier| puts "Result is #{total} (:#{tier})"}
  end

  def scored?
    !score.nil?
  end

  def score_tier
    Feedback.tier_for(score) if scored?
  end

  TIERS.each do |tier|
    instance_eval do
      define_method("#{tier}?") do
        score_tier == tier.to_sym
      end
    end
  end
end
