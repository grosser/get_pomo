name = "get_pomo"
require "./lib/#{name}/version"

Gem::Specification.new name, GetPomo::VERSION do |s|
  s.summary = "Ruby/Gettext: A .po and .mo file parser/generator"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "https://github.com/grosser/#{name}"
  s.files = `git ls-files lib vendor`.split("\n")
  s.license = "MIT"
  s.required_ruby_version = '>= 2.0.0'
end
