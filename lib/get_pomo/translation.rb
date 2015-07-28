module GetPomo
  class Translation
    FUZZY_REGEX = /^#,\s*fuzzy/
    OBSOLETE_REGEX = /^#~\s*msgstr(\s|\[1\]\s)/
    attr_accessor :msgid, :msgstr, :msgctxt, :comment

    def add_text(text,options)
      to = options[:to]
      if to.to_sym == :msgid_plural
        self.msgid = [msgid] unless msgid.is_a? Array
        msgid[1] = msgid[1].to_s + text
      elsif to.to_s =~ /^msgstr\[(\d)\]$/
        self.msgstr ||= []
        msgstr[$1.to_i] = msgstr[$1.to_i].to_s + text
      else
        raise GetPomo::InvalidMethod, "No method found for #{to}" unless self.respond_to?(to)
        send("#{to}=",send(to).to_s+text)
      end
    end

    def to_hash
      {
        :msgctxt => msgctxt,
        :msgid => msgid,
        :msgstr => msgstr,
        :comment => comment
      }.reject { |_,value| value.nil? }
    end

    def complete?
      (not msgid.nil? and not msgstr.nil?) or obsolete?
    end

    def fuzzy?
      !!(comment =~ FUZZY_REGEX)
    end

    def obsolete?
      !!(comment =~ OBSOLETE_REGEX)
    end

    def fuzzy=(value)
      if value and not fuzzy?
        add_text "\n#, fuzzy", :to=>:comment
      else
        self.comment = comment.to_s.split(/$/).reject{|line|line=~FUZZY_REGEX}.join("\n")
      end
    end

    def plural?
      msgid.is_a? Array or msgstr.is_a? Array
    end

    def singular?
      !plural?
    end

    def header?
      msgid == ""
    end
  end
end
