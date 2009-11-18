require 'pomo/po_file'
module Pomo
  VERSION = File.read( File.join(File.dirname(__FILE__),'..','VERSION') ).strip
  
  extend self
  
  def self.unique_translations(translations)
    last_seen_at_index = {}
    translations.each_with_index {|translation,index|last_seen_at_index[translation.msgid]=index}
    last_seen_at_index.values.sort.map{|index| translations[index]}
  end
end