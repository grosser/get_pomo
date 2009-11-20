require File.expand_path("../spec_helper", File.dirname(__FILE__))
require 'get_pomo/mo_file'

include GetPomo
describe GetPomo::MoFile do
  it "parses empty mo file" do
    MoFile.parse(File.read('spec/files/empty.mo')).should == []
  end

  it "parses empty strings" do
    MoFile.parse(File.read('spec/files/empty.mo')).should == []
  end

  it "reads singulars" do
    t = MoFile.parse(File.read('spec/files/singular.mo'))[0]
    t.to_hash.should == {:msgid=>'Back',:msgstr=>'Zurück'}
  end

  it "reads plurals" do
    t = MoFile.parse(File.read('spec/files/plural.mo'))[0]
    t.to_hash.should == {:msgid=>['Axis','Axis'],:msgstr=>['Achse','Achsen']}
  end

  describe 'instance methods' do
    it "combines multiple translations" do
      m = MoFile.new
      m.add_translations_from_text(File.read('spec/files/plural.mo'))
      m.add_translations_from_text(File.read('spec/files/singular.mo'))
      m.should have(2).translations
      m.translations[0].msgid.should_not == m.translations[1].msgid
    end

    it "can be initialized with translations" do
      m = MoFile.new(:translations=>['x'])
      m.translations.should == ['x']
    end

    it "does not generate duplicate translations" do
      second_version = File.read('spec/files/singular_2.mo')
      m = MoFile.new
      m.add_translations_from_text(File.read('spec/files/singular.mo'))
      m.add_translations_from_text(second_version)
      m.to_text.should == second_version
    end
  end

  it "reads metadata" do
    meta = MoFile.parse(File.read('spec/files/complex.mo')).detect {|t|t.msgid == ''}
    meta.msgstr.should_not be_empty
  end

  describe :to_text do
    it "writes singulars" do
      text = File.read('spec/files/singular.mo')
      MoFile.to_text(MoFile.parse(text)).should == text
    end
  end
end