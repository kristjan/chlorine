require 'spec_helper.rb'

context Recruit, "When destroyed" do
  it "destroys its feedback" do
    proc { recruits(:james).destroy }.should change(Feedback, :count).by(-1)
  end

  it "destroys its activities" do
    proc { recruits(:james).destroy }.should change(Activity, :count).by(-2)
  end

  it "destroys its documents" do
    proc { recruits(:james).destroy }.should change(Document, :count).by(-1)
  end
end

