require File.expand_path("../spec_helper", File.dirname(__FILE__))

require 'pomo/translation'

describe Pomo::Translation do
  describe :complete? do
    it{should_not be_complete}

    it "is complete if it has a msgid and a msgstr" do
      subject.msgid="x"
      subject.msgstr = "y"
      should be_complete
    end

    it "is not complete if it has an complete msgid" do
      subject.msgid=""
      should_not be_complete
    end

    it "is not complete if it has a nil msgstr" do
      subject.msgid="x"
      should_not be_complete
    end

    it "is complete if it has an complete msgstr" do
      subject.msgid = "x"
      subject.msgstr = ""
      should be_complete
    end
  end
end