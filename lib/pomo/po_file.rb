require 'pomo/translation'

module Pomo
  class PoFile
    attr_reader :singulars

    def initialize
      @singulars = []
    end

    #the text is split into lines and then converted into logical translations
    #each translation consists of comments(that come before a translation)
    #and a msgid / msgstr
    def add_translations(data)
      start_new_translation
      data.split(/$/).each do |line|
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
    end

    private

    ## fuzzy
    def comment?(line)
      line =~ /^\s*#/
    end

    def add_comment(line)
      start_new_translation if translation_complete?
      @current_translation.comment ||= ""
      @current_translation.comment += line.strip.sub('#','')
    end

    #msgid "hello"
    def method_call?(line)
      line =~ /^\s*[a-z]/
    end

    #msgid "hello" -> method call msgid + add string "hello"
    def parse_method_call(line)
      method, string = line.match(/^\s*([a-z0-9\[\]]+)(.*)/)[1..2]
      raise "no method found" unless method

      start_new_translation if method == 'msgid' and translation_complete?
      @last_method = method.to_sym
      add_string(string)
    end

    #"hello" -> hello
    def add_string(string)
      return if string.strip.empty?
      raise "not string format: #{string.inspect}" unless string.strip =~ /^['"](.*)['"]$/
      @current_translation.send("#{@last_method}=",(@current_translation.send(@last_method)||"") + $1)
    end

    def translation_complete?
      return false unless @current_translation
      @current_translation.complete?
    end
  
    def store_translation
      @singulars += [@current_translation] if @current_translation.complete?
    end

    def start_new_translation
      store_translation if translation_complete?
      @current_translation = Translation.new
    end
  end
end