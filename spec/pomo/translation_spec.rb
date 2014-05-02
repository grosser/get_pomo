require 'spec_helper'
require 'get_pomo/translation'

describe GetPomo::Translation do
  describe "#complete?" do
    it { should_not be_complete }

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

  describe "#add_text" do
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

    it "initializes msgstr and msgid if an obsolete translation is added" do
      subject.add_text("#~ msgid Hello\n#~ msgstr Hallo", :to=>:comment)
      subject.msgstr.should_not be_nil
      subject.msgid.should_not be_nil
    end

  end

  describe "#plural?" do
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

  describe "#singular?" do
    it{should be_singular}

    it "is not singular if msgid is plural" do
      subject.add_text("x",:to=>:msgid_plural)
      should_not be_singular
    end

    it "is not singular if msgstr is plural" do
      subject.add_text("x",:to=>"msgstr[0]")
      should_not be_singular
    end

    it "is singular if simple strings where added" do
      subject.msgid = "a"
      subject.msgstr = "a"
      should be_singular
    end
  end

  describe "#header?" do
    it{should_not be_header}

    it "is header if msgid is empty" do
      subject.msgid = ""
      should be_header
    end

    it "is not header if there is something on msgid" do
      subject.msgid = "a"
      should_not be_header
    end
  end

  describe "#fuzzy?" do
    it{should_not be_fuzzy}

    it "is fuzzy if a fuzzy comment was added" do
      subject.add_text("#, fuzzy",:to=>:comment)
      should be_fuzzy
    end

    it "can be made fuzzy by using fuzzy=" do
      subject.fuzzy = true
      should be_fuzzy
    end

    it "can be made unfuzzy by using fuzzy=" do
      subject.fuzzy = false
      should_not be_fuzzy
    end

    it "changes comment when made fuzzy through fuzzy=" do
      subject.comment = "# hello"
      subject.fuzzy = true
      subject.comment.should == "# hello\n#, fuzzy"
    end

    it "changes empty comment when made fuzzy through fuzzy=" do
      subject.fuzzy = true
      subject.comment.should == "\n#, fuzzy"
    end

    it "preserves comments when making fuzzy/unfuzzy" do
      subject.comment = "hello"
      subject.fuzzy = true
      subject.fuzzy = false
      subject.comment.should == "hello"
    end
  end

  describe "#obsolete?" do
    it { should_not be_obsolete }

    it "is obsolete if a obsolete msgstr comment was added" do
      subject.comment = "#~ msgstr hello"
      subject.obsolete?.should == true
    end
  end
end
