require 'get_pomo/po_file'
module GetPomo
  autoload :VERSION, "get_pomo/version"
  
  extend self

  # A message is unique if the combination of msgid and msgctxt is unique.
  # An emtpy msgctxt does not mean the same thing as no msgctxt.
  # If there are multiple msgid's without msgctxt we use the latest one. If at least one has a msgctxt we completly
  # drop all msgids without msgctxt and do not even mark them for merging. Multiple msgid's with different msgctxt will
  # be treated as unique translations each.
  #
  # @param merge [Bool]  true merges references of non unique translations considering the rules above
  def self.unique_translations(translations, merge = false)
    seen_msgids = {}
    # unique + merge logic
    # hash with msgid's as keys.
    # value is array if that msgid got no msgctxt
    # value is hash if that msgid got a msgctxt
    obsoletes = translations.select{|t| t.obsolete?}
    translations.reject{ |t| t.obsolete?}.each_with_index do |translation, index|
      key = translation.msgid
      if seen_msgids.has_key?(key) # msgid not unique?
        if seen_msgids[key].is_a?(Hash) # other translation with same msgid has a msgctxt?
          if translation.msgctxt # this translation with same msgid has a msgctxt?, if not ignore it
            if seen_msgids[key].has_key?(translation.msgctxt) # is it the same msgctxt?
              seen_msgids[key][translation.msgctxt].push(index)
            else
              seen_msgids[key][translation.msgctxt] = [index]
            end
          end
        else # other translation with same msgid had no msgctxt
          if translation.msgctxt # if other translation has no msgctxt but this one has, just save this new one
            seen_msgids[key] = {translation.msgctxt => [index]}
          else # otherwise just push the new found translation for merge
            seen_msgids[key].push(index)
          end
        end
      else #msgid is unique so far
        if translation.msgctxt # does the msgid got a msgctxt, if so add a nested hash with the msgctxt as key and an index_array as value
          seen_msgids[key] = {translation.msgctxt => [index]}
        else # if not, simply add an index array
          seen_msgids[key] = [index]
        end
      end
    end
    trans_indexes = {} # maps unique translation ids as keys to mergeable ids as value array

    seen_msgids.values.each do |value|
      if value.is_a?(Hash)
        value.values.each do |v|
          id = v.pop
          trans_indexes[id] = []
          v.each do |index|
             trans_indexes[id].push(index)
          end
        end
      else
        id = value.pop
        trans_indexes[id] = []
        value.each do |index|
          trans_indexes[id].push(index)
        end
      end
    end

    trans = trans_indexes.keys.sort.map do |index|
      if merge
        t = translations[index]
        trans_indexes[index].each do |id|
          # sub starting \n# to \r\n as a split on \r\n should be safe
          # (\n would match \\n in text, \r\n does not match \\r\\n)
          # this is still monkey patching but should work fine
          translations[id].comment.gsub(/\n#/, "\r\n#").split(/\r\n/).each do |com|
            # prepend all references to the existing reference
            t.comment.sub!("#:", com.chomp) if com.start_with?("#: ") && !t.comment.include?(com.sub("#:", ''))
          end
        end
        t
      else
        translations[index]
      end
    end
    trans.concat(obsoletes) unless obsoletes.nil?
    trans
  end
end
