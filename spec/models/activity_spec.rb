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

