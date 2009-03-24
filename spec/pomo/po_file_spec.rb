require File.expand_path("../spec_helper", File.dirname(__FILE__))

describe Pomo::PoFile do
  it "parses nothing" do
    subject.add_translations("")
    subject.translations.should be_empty
  end

  it "parses a simple msgid and msgstr" do
    subject.add_translations(%Q(msgid "xxx"\nmsgstr "yyy"))
    subject.translations[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy'}
  end

  it "parses a multiline msgid/msgstr" do
    subject.add_translations(%Q(msgid "xxx"\n"aaa"\n\n\nmsgstr ""\n"bbb"))
    subject.translations[0].to_hash.should == {:msgid=>'xxxaaa',:msgstr=>'bbb'}
  end

  it "parses simple comments" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\nmsgstr "yyy"))
    subject.translations[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"test"}
  end

  it "parses comments above msgstr" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\n#another\nmsgstr "yyy"))
    subject.translations[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"testanother"}
  end

  it "adds two different translations" do
    subject.add_translations(%Q(msgid "xxx"\nmsgstr "yyy"))
    subject.add_translations(%Q(msgid "aaa"\nmsgstr "yyy"))
    subject.translations[1].to_hash.should == {:msgid=>'aaa',:msgstr=>'yyy'}
  end

  it "adds plural translations" do
    subject.add_translations(%Q(msgid "singular"\nmsgid_plural "plural"\nmsgstr[0] "one"\nmsgstr[1] "many"))
    subject.translations[0].to_hash.should == {:msgid=>['singular','plural'],:msgstr=>['one','many']}
  end

  it "does not fail on empty string" do
    subject.add_translations(%Q(\n\n\n\n\n))
  end

  it "shows line number for invalid strings" do
    begin
      subject.add_translations(%Q(\n\n\n\n\nmsgstr "))
      flunk
    rescue Exception => e
      e.to_s.should =~ /line 5/
    end
  end
end