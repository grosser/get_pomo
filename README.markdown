A simple and extendable .mo and .po file parser/generator.  

Advanteges over original [mo](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/mofile.rb) / [po](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/poparser.rb)-parser:

 - simple architecture + easy to extend/modify
 - emtpy msgstr translations are read
 - comments are included
 - fuzzy can be set/unset
 - multiple translations can be combined in a new po file(with comments and fuzzy and ...)
 - po files can be written from any kind of input
 - easy mo-file handling/merging
 - po/mo file handling is identical, if you know one, you know both

Setup
=====
    sudo gem install pomo -s http://gemcutter.org

###Static interface
    #parse po files
    translations = Pomo::PoFile.parse(File.read('xxx.po')) + Pomo::PoFile.parse(File.read('yyy.po'))

    #and use the data...
    msgids = translations.reject{|t|t.plural? or t.fuzzy?}.map(&:msgid)

    #or write a new po file (unique by msgid)...
    File.open('xxx.po','w){|f|f.print(Pomo::PoFile.to_text(translations))}


###Instance interface
    p = PoMo::PoFile.new
    p.add_translations_from_text(File.read('...'))
    ...
    p.translations
    p.to_text

`Pomo::MoFile` behaves identical.

TODO
====
 - extracting of version/pluralisation_rule/plurals/translator... (from msgid "")
 - the vendor/mofile is really complex, maybe it can be refactored (also some parts are not needed)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  