module Pomo
  class Translation
    attr_accessor :msgid, :msgstr, :comment

    def to_hash
      {:msgid=>msgid,:msgstr=>msgstr,:comment=>comment}.reject{|k,value|value.nil?}
    end

    def complete?
      not msgid.to_s.strip.empty? and not msgstr.nil?
    end

    def fuzzy
      comment =~ /^\s*fuzzy\s*$/
    end
  end
end