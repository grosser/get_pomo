require 'rubygems'
require 'treetop'

Treetop.load "po"
parser = PoParser.new
puts parser.parse(%Q(msgid "xxx" "yyy"))