require 'bundler/setup'
require 'bundler/gem_tasks'

task :default do
  sh "rspec spec/"
end

project_name = 'get_pomo'
require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = project_name
  gem.summary = "Ruby/Gettext: A .po and .mo file parser/generator"
  gem.email = "grosser.michael@gmail.com"
  gem.homepage = "http://github.com/grosser/#{project_name}"
  gem.authors = ["Michael Grosser"]
end

Jeweler::GemcutterTasks.new
