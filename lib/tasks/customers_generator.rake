# frozen_string_literal: true

namespace :generator do
  desc 'Creates customers'
  task customers: :environment do
    puts '- Starting customers creation...'

    Tasks::CustomersGenerator.call!

    puts '- Customers creation finished!'
  end
end
