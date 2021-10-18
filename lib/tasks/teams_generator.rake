# frozen_string_literal: true

namespace :generator do
  desc 'Creates teams'
  task teams: :environment do
    puts '- Starting teams creation...'

    Tasks::TeamsGenerator.call!

    puts '- Teams creation finished!'
  end
end
