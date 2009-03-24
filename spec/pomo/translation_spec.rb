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

  describe :add_text do
    it "adds a simple msgid" do
      subject.add_text("x",:to=>:msgid)
      subject.msgid.should == "x"
    end

    it "converts msgid to plural when msgid_plural is added" do
      subject.add_text("x",:to=>:msgid)
      subject.add_text("y",:to=>:msgid_plural)
      subject.msgid.should == ["x",'y']
    end

    it "can add additional text to msgid plurals" do
      subject.add_text("y",:to=>:msgid_plural)
      subject.add_text("a",:to=>:msgid_plural)
      subject.msgid.should == [nil,'ya']
    end

    it "can add plural msggstr" do
      subject.add_text("x",:to=>'msgstr[0]')
      subject.msgstr.should == ['x']
    end

    it "can add multiple plural msggstr" do
      subject.add_text("x",:to=>'msgstr[0]')
      subject.add_text("a",:to=>'msgstr[1]')
      subject.add_text("y",:to=>'msgstr[1]')
      subject.msgstr.should == ['x','ay']
    end
  end

  describe :plural? do
    it{should_not be_plural}

    it "is plural if msgid is plural" do
      subject.add_text("x",:to=>:msgid_plural)
      should be_plural
    end

    it "is plural if msgstr is plural" do
      subject.add_text("x",:to=>"msgstr[0]")
      should be_plural
    end

    it "is not plural if simple strings where added" do
      subject.msgid = "a"
      subject.msgstr = "a"
      should_not be_plural
    end
  end
end