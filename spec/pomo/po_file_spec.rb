require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe Pomo::PoFile do
  it "parses nothing" do
    subject.add_translations("")
    subject.singulars.should be_empty
  end

  it "parses a simple msgid and msgstr" do
    subject.add_translations(%Q(msgid "xxx"\nmsgstr "yyy"))
    subject.singulars[0].should == {:msgid=>'xxx',:msgstr=>'yyy'}
  end

  it "parses a multiline msgid/msgstr" do
    subject.add_translations(%Q(msgid "xxx"\n"aaa"\n\n\nmsgstr ""\n"bbb"))
    subject.singulars[0].should == {:msgid=>'xxxaaa',:msgstr=>'bbb'}
  end

  pending_it "parses comments" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\nmsgstr "yyy"))
    subject.singulars[0].should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"test"}
  end
end