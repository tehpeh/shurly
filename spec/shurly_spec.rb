require 'spec_helper'

describe "Shurly" do
  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end
end