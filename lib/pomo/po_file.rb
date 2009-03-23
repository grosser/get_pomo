require 'rubygems'
require 'ruby_parser'
module Pomo
  class PoFile
    attr_reader :singulars

    def initialize
      @singulars = []
      @translations = []
      @current_translation = {}
    end

    def add_translations(data)
      (RubyParser.new.parse(data)||[]).each do |expression|
#        puts "--#{expression}--"
        next if [nil,:block].include? expression
        if expression.is_a? Sexp
          parse_method_call(expression)
        else
          add_string(expression)
        end
      end
      archive_current_translation
    end

    private

    def parse_method_call(call)
      call.each do |exp|
        next if [nil,:call,:str].include? exp
        case exp
        when :msgid
          archive_current_translation
          @last_method = :msgid
        when Symbol
          @last_method = exp
        when String
          add_string exp
        else
          parse_arglist exp if exp.to_a[0] == :arglist
        end
      end
    end

    def parse_arglist(list)
      add_string(list[1][1])
    end

    def add_string(string)
      @current_translation[@last_method] += string
    end
  
    def archive_current_translation
      @singulars += [@current_translation] unless @current_translation.empty?
      @current_translation = Hash.new("")
    end
  end
end