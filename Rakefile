desc "Run all specs in spec directory"
task :default do |t|
  options = "--colour --format progress --loadby --reverse"
  files = FileList['spec/**/*_spec.rb']
  system("spec #{options} #{files}")
end

begin
  project_name = 'pomo'
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = 'pomo'
    gem.summary = "Ruby/Gettext: A .po and .mo file parser/generator"
    gem.email = "grosser.michael@gmail.com"
    gem.homepage = "http://github.com/grosser/#{project_name}"
    gem.authors = ["Michael Grosser"]
    gem.files = (FileList["{vendor,lib,spec}/**/*"] + FileList["VERSION.yml"] + FileList["README.markdown"]).to_a.sort
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end