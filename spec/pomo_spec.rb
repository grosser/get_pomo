require 'spec/spec_helper'

describe Pomo do
  it "has a VERSION" do
    Pomo::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end