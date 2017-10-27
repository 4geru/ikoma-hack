require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require './models'

RSpec::Core::RakeTask.new(:spec)
# rake task
Dir.glob('tasks/*.rake').each { |r| load r}

# task :default => :spec