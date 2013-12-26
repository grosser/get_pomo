require "spec_helper"
require "get_pomo/po_file"

describe GetPomo::PoFile do
  describe :parse do
    it "parses nothing" do
      GetPomo::PoFile.parse("").should be_empty
    end

    it "parses a simple msgid and msgstr" do
      t = GetPomo::PoFile.parse(%Q(msgid "xxx"\nmsgstr "yyy"))
      t[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy'}
    end

    it "parses msgid and msgstr with escaping quote" do
      t = GetPomo::PoFile.parse('msgid "x\"xx"' + "\n" + 'msgstr "y\"yy"')
      t[0].to_hash.should == {:msgid=>'x"xx',:msgstr=>'y"yy'}
    end

    it "parses a simple msgid and msg with additional whitespace" do
      t = GetPomo::PoFile.parse(%Q(  msgid    "xxx"   \n   msgstr    "yyy"   ))
      t[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy'}
    end

    it "parses an empty msgid with text (gettext meta data)" do
      t = GetPomo::PoFile.parse(%Q(msgid ""\nmsgstr "PLURAL FORMS"))
      t[0].to_hash.should == {:msgid=>'',:msgstr=>'PLURAL FORMS'}
    end

    it "parses a multiline msgid/msgstr" do
      t = GetPomo::PoFile.parse(%Q(msgid "xxx"\n"aaa"\n\n\nmsgstr ""\n"bbb"))
      t[0].to_hash.should == {:msgid=>'xxxaaa',:msgstr=>'bbb'}
    end

    it "parses simple comments" do
      t = GetPomo::PoFile.parse(%Q(#test\nmsgid "xxx"\nmsgstr "yyy"))
      t[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"#test\n"}
    end

    it "parses comments above msgstr" do
      t = GetPomo::PoFile.parse(%Q(#test\nmsgid "xxx"\n#another\nmsgstr "yyy"))
      t[0].to_hash.should == {:msgid=>'xxx',:msgstr=>'yyy',:comment=>"#test\n#another\n"}
    end

    it "parses a simple string with msgctxt" do
      t = GetPomo::PoFile.parse(%Q(msgctxt "www"\nmsgid "xxx"\nmsgstr "yyy"))
      t[0].to_hash.should == {:msgctxt => 'www', :msgid=>'xxx',:msgstr=>'yyy'}
    end
  end

  describe "instance interface" do
    it "adds two different translations" do
      p = GetPomo::PoFile.new
      p.add_translations_from_text(%Q(msgid "xxx"\nmsgstr "yyy"))
      p.add_translations_from_text(%Q(msgid "aaa"\nmsgstr "yyy"))
      p.translations[1].to_hash.should == {:msgid=>'aaa',:msgstr=>'yyy'}
    end

    it "can be initialized with translations" do
      p = GetPomo::PoFile.new(:translations=>['xxx'])
      p.translations[0].should == 'xxx'
    end

    it "can be converted to text" do
      text = %Q(msgid "xxx"\nmsgstr "aaa")
      p = GetPomo::PoFile.new
      p.add_translations_from_text(text)
      p.to_text.should == text
    end

    it "keeps uniqueness when converting to_text" do
      text = %Q(msgid "xxx"\nmsgstr "aaa")
      p = GetPomo::PoFile.new
      p.add_translations_from_text(%Q(msgid "xxx"\nmsgstr "yyy"))
      p.add_translations_from_text(text)
      p.to_text.should == text
    end

    it "outputs the msgctxt when present" do
      text = %Q(msgctxt "zzz"\nmsgid "xxx"\nmsgstr "aaa")
      p = GetPomo::PoFile.new
      p.add_translations_from_text(%Q(msgid "xxx"\nmsgstr "yyy"))
      p.add_translations_from_text(text)
      p.to_text.should == text
    end
  end

  it "adds plural translations" do
    t = GetPomo::PoFile.parse(%Q(msgid "singular"\nmsgid_plural "plural"\nmsgstr[0] "one"\nmsgstr[1] "many"))
    t[0].to_hash.should == {:msgid=>['singular','plural'],:msgstr=>['one','many']}
  end

  it "does not fail on empty string" do
    GetPomo::PoFile.parse(%Q(\n\n\n\n\n))
  end

  it "shows line number for invalid strings" do
    begin
      GetPomo::PoFile.parse(%Q(\n\n\n\n\nmsgstr "))
      flunk
    rescue Exception => e
      e.to_s.should =~ /line 5/
    end
  end

  describe :to_text do
    it "is empty when not translations where added" do
      GetPomo::PoFile.to_text([]).should == ""
    end

    it "preserves simple syntax" do
      text = %Q(msgid "x"\nmsgstr "y")
      GetPomo::PoFile.to_text(GetPomo::PoFile.parse(text)).should == text
    end

    it "escape double quotes" do
      text = 'msgid "x\"xx"' + "\n" + 'msgstr "y\"yy"'
      po = GetPomo::PoFile.parse(text)
      GetPomo::PoFile.to_text(po).should == text
    end

    it "does not escape slashes" do
      text = 'msgid "x\\"' + "\n" + 'msgstr "x\\"'
      po = GetPomo::PoFile.parse(text)
      GetPomo::PoFile.to_text(po).should == text
    end

    it "escape double quotes on plurals" do
      text = 'msgid "x\"xx"' + "\n"
      text += 'msgid_plural "x\"xx"' + "\n"
      text += 'msgstr[0] "y\"yy"' + "\n"
      text += 'msgstr[1] "y\"yy"'
      po = GetPomo::PoFile.parse(text)
      GetPomo::PoFile.to_text(po).should == text
    end

    it "adds comments" do
      t = GetPomo::Translation.new
      t.msgid = 'a'
      t.msgstr = 'b'
      t.add_text("#c\n",:to=>:comment)
      t.add_text("#d\n",:to=>:comment)
      GetPomo::PoFile.to_text([t]).should == %Q(#c\n#d\nmsgid "a"\nmsgstr "b")
    end

    it "uses plural notation" do
      text = %Q(#awesome\nmsgid "one"\nmsgid_plural "many"\nmsgstr[0] "1"\nmsgstr[1] "n")
      GetPomo::PoFile.to_text(GetPomo::PoFile.parse(text)).should == text
    end

    it "only uses the latest of identicals msgids" do
      text = %Q(msgid "one"\nmsgstr "1"\nmsgid "one"\nmsgstr "001")
      GetPomo::PoFile.to_text(GetPomo::PoFile.parse(text)).should ==  %Q(msgid "one"\nmsgstr "001")
    end
  end
end
