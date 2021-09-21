# frozen_string_literal: true

namespace :generator do
  desc 'Creates states and cities register'
  task places: :environment do
    puts '- Starting places generation...'

    Tasks::PlacesGenerator.call!

    puts '- Places generation finished!'
  end
end
