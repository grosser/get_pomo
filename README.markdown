A simple and extendable .mo and .po file parser/generator.  
--mo file parser and writer are missing atm--

Advanteges over [original po-parser](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/poparser.rb):  
 - simple architecture + easy to extend/modify
 - emtpy msgstr translations are read
 - comments are included
 - fuzzy can be set/unset
 - multiple translations can be combined in a new po file(with comments and fuzzy and ...)
 - po files can be written from any kind of input

Setup
=====
    sudo gem install grosser-pomo -s http://gems.github.com/

    #parse po files
    p = Pomo::PoFile.new
    p.add_translations(File.read('xxx.po'))
    p.add_translations(File.read('yyy.po'))

    #and use the data...
    msgids = p.translations.reject{|t|t.plural? or t.fuzzy?}.map(&:msgid)

    #or write a new po file (unique by msgid)...
    File.open('xxx.po','w){|f|f.print(p.to_text)}

TODO
====
 - extracting of version/pluralisation_rule/plurals/translator... (from msgid "")
 - mo writing/reading (this is the hardest part imo...)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  