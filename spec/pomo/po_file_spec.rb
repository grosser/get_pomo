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
    subject.translations[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"test\n"}
  end

  it "parses comments above msgstr" do
    subject.add_translations(%Q(#test\nmsgid "xxx"\n#another\nmsgstr "yyy"))
    subject.translations[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"test\nanother\n"}
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

  describe :to_text do
    it "is empty when not translations where added" do
      subject.to_text.should == ""
    end
    
    it "preserves simple syntax" do
      text = %Q(msgid "x"\nmsgstr "y")
      subject.add_translations(text)
      subject.to_text.should == text
    end

    it "adds comments" do
      t = Pomo::Translation.new
      t.msgid = 'a'
      t.msgstr = 'b'
      t.add_text("c\n",:to=>:comment)
      t.add_text("d\n",:to=>:comment)
      subject.translations << t
      subject.to_text.should == %Q(#c\n#d\nmsgid "a"\nmsgstr "b")
    end

    it "uses plural notation" do
      text = %Q(#awesome\nmsgid "one"\nmsgid_plural "many"\nmsgstr[0] "1"\nmsgstr[1] "n")
      subject.add_translations(text)
      subject.to_text.should == text
    end

    it "only uses the latest of identicals msgids" do
      text = %Q(msgid "one"\nmsgstr "1"\nmsgid "one"\nmsgstr "001")
      subject.add_translations(text)
      subject.to_text.should == %Q(msgid "one"\nmsgstr "001")
    end
  end
end