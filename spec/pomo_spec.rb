require 'spec_helper'

describe GetPomo do
  it "has a VERSION" do
    GetPomo::VERSION.should =~ /^\d+\.\d+\.\d+$/
  end

  it "scans unique translations correctly" do
    t = GetPomo::PoFile.parse(File.read('spec/files/uniques.po'))
    t = GetPomo.unique_translations(t)
    t.reject!{ |tx| tx.obsolete?}
    t[0].to_hash.should == {:msgid => "", :msgstr => "", :comment => "# Unique translation test fixture\n#\n#, fuzzy\n"}
    t[1].to_hash.should == {:msgctxt => "context1", :msgid => "xxx", :msgstr => "xyz", :comment => "#: Reference1\n"}
    t[2].to_hash.should == {:msgctxt => "context2", :msgid => "xxx", :msgstr => "yyy", :comment => "#: Reference3\n"}
    t[3].to_hash.should == {:msgctxt => "", :msgid => "xxx", :msgstr => "yyy", :comment => "#: Reference4\n"}
    t[4].to_hash.should == {:msgid => "xyz", :msgstr => "zyx", :comment => "# translator comment\n#: Reference6\n#, aflag\n"}
    t[5].to_hash.should == {:msgid => "xzy", :msgstr => "yxy", :comment => "#: Reference7\n"}
  end

  it "merges non unique translations correctly" do
    t = GetPomo::PoFile.parse(File.read('spec/files/uniques.po'))
    t = GetPomo.unique_translations(t, true)
    t.reject!{ |tx| tx.obsolete?}
    t[0].to_hash.should == {:msgid => "", :msgstr => "", :comment => "# Unique translation test fixture\n#\n#, fuzzy\n"}
    t[1].to_hash.should == {:msgctxt => "context1", :msgid => "xxx", :msgstr => "xyz", :comment => "#: Reference1\n"}
    t[2].to_hash.should == {:msgctxt => "context2", :msgid => "xxx", :msgstr => "yyy", :comment => "#: Reference2 Reference3\n"}
    t[3].to_hash.should == {:msgctxt => "", :msgid => "xxx", :msgstr => "yyy", :comment => "#: Reference4\n"}
    t[4].to_hash.should == {:msgid => "xyz", :msgstr => "zyx", :comment => "# translator comment\n#: Reference8 Reference6\n#, aflag\n"}
    t[5].to_hash.should == {:msgid => "xzy", :msgstr => "yxy", :comment => "#: Reference7\n"}
  end
end
