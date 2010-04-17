require File.dirname(__FILE__) + '/../spec_helper'

describe UploadFile do
  before(:each) do
    @upload_file = UploadFile.new
  end

  it "should be valid" do
    @upload_file.should be_valid
  end
end
