require 'get_pomo/po_file'
module GetPomo
  autoload :VERSION, "get_pomo/version"
  
  extend self

  # merge = true merges references of non unique translations
  def self.unique_translations(translations, merge = false)
    seen_at_indexes = {}
    translations.each_with_index do |translation, index|
      key = translation.msgid
      key += "+" + translation.msgctxt if translation.msgctxt #some additional character required as empty msgctxt != no msgctxt
      if seen_at_indexes.has_key?(key)
        seen_at_indexes[key].push(index)
      else
        seen_at_indexes[key] = [index]
      end
    end
    seen_at_indexes.values.map do |indexes|
      if merge
        trans = translations[indexes.pop]
        indexes.each do |index|
          # sub starting \n# to \r\n as a split on \r\n should be safe
          # (\n would match \\n in text, \r\n does not match \\r\\n)
          # this is still monkey patching but should work fine
          translations[index].comment.gsub(/\n#/, "\r\n#").split(/\r\n/).each do |com|
            # append all references on top of the existing comment
            trans.comment = com.chomp + "\n" + trans.comment if com.start_with?("#: ")
          end
        end
      else
        trans = translations[indexes.last]
      end
      trans
    end
  end
end
