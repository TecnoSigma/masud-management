# frozen_string_literal: true

desc 'Creates states and cities register'
  task places_generator: :environment do
    puts '- Starting places generation...'

    Tasks::PlacesGenerator.call!

    puts '- Places generation finished!'
end
