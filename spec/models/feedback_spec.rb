require 'spec_helper.rb'

describe Feedback do
  it "knows when it's awesome" do
    [1.1, 1.5, 2].each do |score|
      Feedback.new(:score => score).should be_awesome
    end
  end

  it "knows when it's good" do
    [0.1, 0.5, 1].each do |score|
      Feedback.new(:score => score).should be_good
    end
  end

  it "knows when it's neutral" do
    Feedback.new(:score => 0).should be_neutral
  end

  it "knows when it's bad" do
    [-0.1, -0.5, -0.9].each do |score|
      Feedback.new(:score => score).should be_bad
    end
  end

  it "knows when it's awful" do
    [-1, -1.5, -2].each do |score|
      Feedback.new(:score => score).should be_awful
    end
  end
end
