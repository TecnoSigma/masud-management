# frozen_string_literal: true

namespace :generator do
  desc 'Creates agents'
  task agents: :environment do
    puts '- Starting agents creation...'

    Tasks::AgentsGenerator.call!

    puts '- Agents creation finished!'
  end
end
