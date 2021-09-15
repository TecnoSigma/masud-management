require "rubycritic/rake_task"

RubyCritic::RakeTask.new do |task|
  task.name    = 'rubycritic'
  task.paths   = FileList['app/', 'lib/']
  task.options = '--minimum-score 90'
  task.verbose = true
end

