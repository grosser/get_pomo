require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe Pomo::PoFile do
  it "parses nothing" do
    subject.add_translations("")
    subject.singulars.should be_empty
  end

  it "parses a simple msgid and msgstr" do
    subject.add_translations(%Q(msgid "xxx"\nmsgstr "yyy"))
    subject.singulars[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy'}
  end

  it "parses a multiline msgid/msgstr" do
    subject.add_translations(%Q(msgid "xxx"\n"aaa"\n\n\nmsgstr ""\n"bbb"))
    subject.singulars[0].to_hash.should == {:msgid=>'xxxaaa',:msgstr=>'bbb'}
  end

  it "parses simple comments" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\nmsgstr "yyy"))
    subject.singulars[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"test"}
  end

  it "parses comments above msgstr" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\n#another\nmsgstr "yyy"))
    subject.singulars[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"testanother"}
  end

  it "adds two different translations" do
    subject.add_translations(%Q(msgid "xxx"\nmsgstr "yyy"))
    subject.add_translations(%Q(msgid "aaa"\nmsgstr "yyy"))
    subject.singulars[1].to_hash.should == {:msgid=>'aaa',:msgstr=>'yyy'}
  end
end