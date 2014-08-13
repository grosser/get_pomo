#encoding: utf-8
require 'get_pomo/translation'

module GetPomo
  class PoFile
    def self.parse(text)
      PoFile.new.add_translations_from_text(text)
    end

    def self.to_text(translations, merge = false)
      p = PoFile.new(:translations=>translations)
      p.to_text(merge)
    end

    attr_reader :translations

    def initialize(options = {})
      @translations = options[:translations] || []
    end

    #the text is split into lines and then converted into logical translations
    #each translation consists of comments(that come before a translation)
    #and a msgid / msgstr
    def add_translations_from_text(text)
      start_new_translation
      text.gsub!(/^#{"\357\273\277"}/, "") #remove boom
      text.split(/$/).each_with_index do |line,index|
        @line_number = index + 1
        next if line.empty?
        if method_call? line
          parse_method_call line
        elsif comment? line
          add_comment line
        else
          add_string line
        end
      end
      start_new_translation #instance_variable has to be overwritten or errors can occur on next add
      translations
    end

    def to_text(merge = false)
      GetPomo.unique_translations(translations, merge).map do |translation|
        comment = translation.comment.to_s.split(/\n|\r\n/).map{|line|"#{line}\n"}*''

        msgctxt = if translation.msgctxt
          %Q(msgctxt "#{translation.msgctxt}"\n)
        else
          ""
        end

        msgid_and_msgstr = if translation.plural?
          msgids =
          %Q(msgid "#{translation.msgid[0]}"\n)+
          %Q(msgid_plural "#{translation.msgid[1]}"\n)

          msgstrs = []
          translation.msgstr.each_with_index do |msgstr,index|
            msgstrs << %Q(msgstr[#{index}] "#{msgstr}")
          end

          msgids + (msgstrs*"\n")
        else
          %Q(msgid "#{translation.msgid}"\n)+
          %Q(msgstr "#{translation.msgstr}")
        end

        comment + msgctxt + msgid_and_msgstr
      end * "\n\n"
    end

    private

    #e.g. # fuzzy
    def comment?(line)
      line =~ /^\s*#/
    end

    def add_comment(line)
      start_new_translation if translation_complete?
      @current_translation.add_text(line.strip+"\n",:to=>:comment)
    end

    #msgid "hello"
    def method_call?(line)
      line =~ /^\s*[a-z]/
    end

    #msgid "hello" -> method call msgid + add string "hello"
    def parse_method_call(line)
      method, string = line.match(/^\s*([a-z0-9_\[\]]+)(.*)/)[1..2]
      raise "no method found" unless method

      start_new_translation if %W(msgid msgctxt msgctxt).include? method and translation_complete?
      @last_method = method.to_sym
      add_string(string)
    end

    #"hello" -> hello
    def add_string(string)
      string = string.strip
      return if string.empty?
      raise "not string format: #{string.inspect} on line #{@line_number}" unless string =~ /^['"](.*)['"]$/
      string_content = string[1..-2] #remove leading and trailing quotes from content
      @current_translation.add_text(string_content, :to=>@last_method)
    end

    def translation_complete?
      return false unless @current_translation
      @current_translation.complete?
    end

    def store_translation
      @translations += [@current_translation] if @current_translation.complete?
    end

    def start_new_translation
      store_translation if translation_complete?
      @current_translation = Translation.new
    end
  end
end