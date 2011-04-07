require 'spec_helper'

describe "Shurly" do
  it "responds to /" do
    get '/'
    last_response.should be_ok
  end
end