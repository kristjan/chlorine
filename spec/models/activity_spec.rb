require 'spec_helper.rb'

context Activity, "When destroyed" do
  it "destroys its feedback" do
    proc { activities(:james_phone_intro).destroy }.
      should change(Feedback, :count).by(-1)
  end

  it "destroys its assignments" do
    proc { activities(:james_phone_intro).destroy }.
      should change(EmployeeActivity, :count).by(-1)
  end
end

context Activity, "An activity" do
  Activity::FEEDBACK_ACTIVITIES.each_with_index do |activity_class, i|
    it "knows what activities need feedback after #{activity_class.friendly_name}" do
      activity_class.new.feedback_activities_left.should ==
        Activity::FEEDBACK_ACTIVITIES[(i+1)..-1]
    end
  end
end
