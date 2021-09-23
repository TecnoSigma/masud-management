# frozen_string_literal: true

namespace :generator do
  desc 'Creates vehicles'
  task vehicles: :environment do
    puts '- Starting vehicles creation...'

    Tasks::VehiclesGenerator.call!

    puts '- Vehicles creation finished!'
  end
end
