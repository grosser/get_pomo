This is still experimental, a po/mo file reader, because i hate the unclear/hackish way gettext does it.
So far the only thing works is reading po files.

An advantage here is that e.g. also emtpy msgstr translations are read.

Setup
=====
    sudo gem install grosser-pomo -s http://gems.github.com/
    p = Pomo::PoFile.new
    p.add_translations(File.read('xxx.po'))

TODO
====
 - parsing of comments
 - pluralisation
 - po writing
 - mo writing/reading (this is the hardest part imo...)

Author
======
[Michael Grosser](http://pragmatig.wordpress.com)  
grosser.michael@gmail.com  
Hereby placed under public domain, do what you want, just do not hold me accountable...  