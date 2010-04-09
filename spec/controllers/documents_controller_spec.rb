require 'spec_helper.rb'

context DocumentsController, "Response disposition" do
  it "is inline for images" do
    pending("Figuring out where the disposition header is in the test response")
    get documents(:james_headshot).id
    puts response.headers.inspect
    response.disposition.should be 'inline'
  end

  it "is inline for txt" do
    pending("Figuring out where the disposition header is in the test response")
    get documents(:james_cover_letter).id
    response.disposition.should be 'inline'
  end

  it "is attachment for everything else" do
    pending("Figuring out where the disposition header is in the test response")
    get documents(:james_resume).id
    response.disposition.should be 'attachment'
  end
end

