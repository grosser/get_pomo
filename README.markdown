This is still experimental, a po/mo file reader, because i hate the unclear/hackish way gettext does it.
So far the only thing works is reading po files.

Advanteges over [original po-parser](http://github.com/mutoh/gettext/blob/abf96713327cc4c5d35f0a772f3b75ff4819450c/lib/gettext/poparser.rb):
 - simple architecture + easy to extend/modify
 - emtpy msgstr translations are read
 - comments are included

Setup
=====
    sudo gem install grosser-pomo -s http://gems.github.com/

    #parse po files
    p = Pomo::PoFile.new
    p.add_translations(File.read('xxx.po'))

    #and use the data...
    msgids = p.translations.reject{|t|t.plural? or t.fuzzy?}.map(&:msgid)

TODO
====
 - parsing of fuzzy / created_at
 - po writing
 - mo writing/reading (this is the hardest part imo...)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  