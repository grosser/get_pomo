require 'get_pomo/po_file'
module GetPomo
  autoload :VERSION, "get_pomo/version"
  
  extend self
  
  def self.unique_translations(translations)
    last_seen_at_index = {}
    translations.each_with_index {|translation,index|last_seen_at_index[translation.msgid]=index}
    last_seen_at_index.values.sort.map{|index| translations[index]}
  end
end
