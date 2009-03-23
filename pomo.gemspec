# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{pomo}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Grosser"]
  s.date = %q{2009-03-23}
  s.email = %q{grosser.michael@gmail.com}
  s.files = ["VERSION.yml", "README.markdown", "lib/pomo", "lib/pomo/po_file.rb", "lib/pomo.rb", "spec/pomo", "spec/pomo/po_file_spec.rb", "spec/spec_helper.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/grosser/pomo}
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Ruby/Gettext: A .po and .mo file parser/generator}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ruby_parser>, [">= 0"])
    else
      s.add_dependency(%q<ruby_parser>, [">= 0"])
    end
  else
    s.add_dependency(%q<ruby_parser>, [">= 0"])
  end
end