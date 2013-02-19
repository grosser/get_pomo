$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "get_pomo"
require "#{name}/version"

Gem::Specification.new name, GetPomo::VERSION do |s|
  s.summary = "Ruby/Gettext: A .po and .mo file parser/generator"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
end
