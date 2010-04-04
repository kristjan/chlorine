require 'spec_helper.rb'

def feedbacks_with(*scores)
  scores.flatten.map{|score| Feedback.new(:score => score)}
end

describe Feedback do
  it "knows it's score tier" do
    [ [[-2, -1],     :awful  ],
      [[-0.9, -0.1], :bad    ],
      [[0],          :neutral],
      [[0.1, 0.9],   :good   ],
      [[1, 2],       :awesome] ].each do |(scores, tier)|
        feedbacks_with(scores).each do |feedback|
          feedback.score_tier.should == tier
        end
      end
  end

  it "knows when it's awesome" do
    feedbacks_with(1, 1.5, 2).should_all be_awesome
  end

  it "knows when it's good" do
    feedbacks_with(0.1, 0.5, 0.9).should_all be_good
  end

  it "knows when it's neutral" do
    feedbacks_with(0).should_all be_neutral
  end

  it "knows when it's bad" do
    feedbacks_with(-0.1, -0.5, -0.9).should_all be_bad
  end

  it "knows when it's awful" do
    feedbacks_with(-1, -1.5, -2).should_all be_awful
  end
end

describe Feedback, "A round of feedback" do
  it "autofails two strong negatives" do
    [
      [-2, -2, 0, 0],
      [-2, -2, 0, 0.5],
      [-2, -2, 0, 2],
      [-2, -2, 0.5, 0.5],
      [-2, -2, 0.5, 2],
      [-2, -2, 2, 2],
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :awful]
      end
  end

  it "can't cancel a strong negative without two strong positives" do
    [
      [-2, 0, 0, 0],
      [-2, 0, 0, 0.5],
      [-2, 0, 0, 2],
      [-2, 0, 0.5, 0.5],
      [-2, 0, 0.5, 2],
      [-2, 0.5, 0.5, 0.5],
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :awful]
    end
  end

  it "can cancel a strong negative with two strong positives" do
    [
      [[-2, 0, 2, 2],   :neutral],
      [[-2, 2, 2, 2],   :good],
    ].each do |scores, expected_tier|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, expected_tier]
    end
  end

  it "can't cancel a weak negative without a strong positive" do
    [
      [-0.5, -0.5, 0, 0],
      [-0.5, -0.5, 0, 0.5],
      [-0.5, -0.5, 0, 2],
      [-0.5, -0.5, 0.5, 0.5],
      [-0.5, -0.5, 0.5, 2],
      [-0.5, 0, 0, 0],
      [-0.5, 0, 0, 0.5],
      [-0.5, 0, 0.5, 0.5],
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :bad]
    end
  end

  it "can cancel a weak negative with a strong positive" do
    [
      [-0.5, 0, 0.5, 2],
      [-0.5, 0, 2, 2],
      [-0.5, 0.5, 0.5, 2],
      [-0.5, 0.5, 2, 2],
      [-0.5, 2, 2, 2],
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :good]
    end
  end

  it "requires one strong positive to pass" do
    [
      [0, 0, 0, 0.5],
      [0, 0, 0.5, 0.5],
      [0, 0.5, 0.5, 0.5],
      [0.5, 0.5, 0.5, 0.5],
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :neutral]
    end
  end

  it "notices when everyone is psyched" do
    [
      [0, 2, 2, 2],
      [0.5, 0.5, 2, 2],
      [0.5, 2, 2, 2],
      [2, 2, 2, 2]
    ].each do |scores|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, :awesome]
    end
  end

  it "doesn't know what to do with tricky ones" do
    pending "moral absoluteness"
    [
      [[-0.5, 0, 0, 2], :neutral],
      [[-0.5, 0.5, 0.5, 0.5], :neutral],
      [[-2, 0.5, 0.5, 2], :neutral],
      [[-2, 0.5, 2, 2],   :neutral],
      [[-0.5, -0.5, 2, 2], :neutral],
    ].each do |scores, expected_tier|
        tier = Feedback.overall_tier(feedbacks_with(scores))
        [scores, tier].should == [scores, expected_tier]
    end
  end
end
