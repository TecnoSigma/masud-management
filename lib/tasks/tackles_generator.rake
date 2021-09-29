# frozen_string_literal: true

namespace :generator do
  desc 'Creates tackles'
  task tackles: :environment do
    puts '- Starting tackles generation...'

    Tasks::TacklesGenerator.call!

    puts '- Tackles generation finished!'
  end
end
