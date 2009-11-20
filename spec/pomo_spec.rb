require 'spec/spec_helper'

describe GetPomo do
  it "has a VERSION" do
    GetPomo::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end
end