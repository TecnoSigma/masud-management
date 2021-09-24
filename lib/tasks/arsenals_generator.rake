# frozen_string_literal: true

namespace :generator do
  desc 'Creates arsenals'
  task arsenals: :environment do
    puts '- Starting arsenals creation...'

    Tasks::ArsenalsGenerator.call!

    puts '- Arsenals creation finished!'
  end
end
