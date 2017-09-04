require 'get_pomo/translation'
require File.join(File.dirname(__FILE__),'..','..','vendor','mofile')

module GetPomo
  class MoFile
    PLURAL_SEPARATOR = "\000"
    CONTEXT_SEPARATOR = "\u0004"

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

        if has_context? msgid
          translation.msgctxt, msgid = msgid.split CONTEXT_SEPARATOR
        end

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
      GetPomo.unique_translations(translations).each do |t| 
        key = [t.msgctxt, plural_to_string(t.msgid)].compact * CONTEXT_SEPARATOR
        m[key] = plural_to_string(t.msgstr)
      end

      io = StringIO.new
      m.save_to_stream io
      io.rewind
      io.read
    end

    private

    def plural_to_string(plural_or_singular)
      [*plural_or_singular] * PLURAL_SEPARATOR
    end

    def has_context? string
      string.include? CONTEXT_SEPARATOR
    end

    def plural? string
      string.include? PLURAL_SEPARATOR
    end

    def split_plural string
      string.split PLURAL_SEPARATOR
    end
  end
end
