This project is no longer maintained. 

If you only need to handle PO files you might want to check out [PoParser](https://github.com/arashm/PoParser)

If you only need the raw PO data parsed to a ruby hash check out PoParser's core [simple_po_parser](https://github.com/experteer/simple_po_parser)

get_pomo
===
A simple and extendable .mo and .po file parser/generator.

Advanteges over original [mo](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/mofile.rb) / [po](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/poparser.rb)-parser:

 - simple architecture + easy to extend/modify
 - emtpy msgstr translations are read
 - comments are included
 - obsolete translations are included if enabled
 - fuzzy can be set/unset
 - references of non unique translations can be merged
 - multiple translations can be combined in a new po file(with comments and fuzzy and ...)
 - po files can be written from any kind of input
 - easy mo-file handling/merging
 - po/mo file handling is identical, if you know one, you know both

Setup
=====
    sudo gem install get_pomo

### Static interface
```
    #parse po files, first with obsolete messages second without
    translations = GetPomo::PoFile.parse(File.read('xxx.po'), :parse_obsoletes => true) + GetPomo::PoFile.parse(File.read('yyy.po'))

    #and use the data...
    msgids = translations.reject{|t|t.plural? or t.fuzzy? or t.obsolete?}.map(&:msgid)

    #or write a new po file (unique by msgid, with merged references for non uniques)...
    File.open('xxx.po','w){|f|f.print(GetPomo::PoFile.to_text(translations, :merge => true))}
```

### Instance interface
    p = GetPomo::PoFile.new
    p.add_translations_from_text(File.read('...'))
    ...
    p.translations
    p.to_text

`GetPomo::MoFile` behaves identical.

TODO
====
 - extracting of version/pluralisation_rule/plurals/translator... (from msgid "")
 - the vendor/mofile is really complex, maybe it can be refactored (also some parts are not needed)

Authors
=======

### [Contributors](https://github.com/grosser/get_pomo/contributors)
 - [Dennis-Florian Herr](https://github.com/dfherr)
 - [Felipe Tanus](https://github.com/fotanus)
 - [Laurent Dang](https://github.com/haeky)

[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/get_pomo.png)](https://travis-ci.org/grosser/get_pomo)
