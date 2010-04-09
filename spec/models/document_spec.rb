require 'spec_helper'

context Document, "Response disposition" do
  it "is inline for images" do
    Document.new(:content_type => 'image/jpeg').
      disposition.should == 'inline'
  end

  it "is inline for text" do
    Document.new(:content_type => 'text/plain').
      disposition.should == 'inline'
  end

  it "is attachment otherwise" do
    Document.new(:content_type => 'application/pdf').
      disposition.should == 'attachment'
  end
end
