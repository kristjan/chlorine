require 'spec_helper.rb'

context Recruit do
  context "When destroyed" do
    it "destroys its feedback" do
      proc { recruits(:james).destroy }.should change(Feedback, :count).by(-1)
    end

    it "destroys its activities" do
      proc { recruits(:james).destroy }.should change(Activity, :count).by(-2)
    end

    it "destroys its documents" do
      proc { recruits(:james).destroy }.should change(Document, :count).by(-3)
    end
  end

  context "When demoted" do
    it "un-completes the previous activity" do
      james = recruits(:james)
      james.demote!
      james.current_activity.should be_a(Activity::New)
      james.current_activity.completed_at.should be_nil
    end
  end
end
