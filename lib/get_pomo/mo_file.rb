require 'get_pomo/translation'
require File.join(File.dirname(__FILE__),'..','..','vendor','mofile')

module GetPomo
  class MoFile
    PLURAL_SEPERATOR = "\000"

    def self.parse(text)
      MoFile.new.add_translations_from_text(text)
    end

    def self.to_text(translations)
      m = MoFile.new(:translations=>translations)
      m.to_text
    end

    attr_reader :translations

    def initialize(options = {})
      @translations = options[:translations] || []
    end

    def add_translations_from_text(text)
      text = StringIO.new(text)
      @translations += GetPomo::GetText::MOFile.open(text, "UTF-8").map do |msgid,msgstr|
        translation = Translation.new
        if plural? msgid or plural? msgstr
          translation.msgid = split_plural(msgid)
          translation.msgstr = split_plural(msgstr)
        else
          translation.msgid = msgid
          translation.msgstr = msgstr
        end
        translation
      end
    end

    def to_text
      m = GetPomo::GetText::MOFile.new
      GetPomo.unique_translations(translations).each {|t| m[plural_to_string(t.msgid)] = plural_to_string(t.msgstr)}

      io = StringIO.new
      m.save_to_stream io
      io.rewind
      io.read
    end

    private

    def plural_to_string(plural_or_singular)
      [*plural_or_singular] * PLURAL_SEPERATOR
    end

    def plural? string
      string.include? PLURAL_SEPERATOR
    end

    def split_plural string
      string.split PLURAL_SEPERATOR
    end
  end
end
