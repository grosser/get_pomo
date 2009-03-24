module Pomo
  class Translation
    attr_accessor :msgid, :msgstr, :comment

    def add_text(text,options)
      to = options[:to]
      if to.to_sym == :msgid_plural
        self.msgid = [msgid] unless msgid.is_a? Array
        msgid[1] = msgid[1].to_s + text
      elsif to.to_s =~ /^msgstr\[(\d)\]$/
        self.msgstr ||= []
        msgstr[$1.to_i] = msgstr[$1.to_i].to_s + text
      else
        #simple form
        send("#{to}=",send(to).to_s+text)
      end
    end

    def to_hash
      {:msgid=>msgid,:msgstr=>msgstr,:comment=>comment}.reject{|k,value|value.nil?}
    end

    def complete?
      not msgid.to_s.strip.empty? and not msgstr.nil?
    end

    def fuzzy?
      comment =~ /^\s*fuzzy\s*$/
    end

    def plural?
      msgid.is_a? Array or msgstr.is_a? Array
    end
  end
end