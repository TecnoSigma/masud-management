# frozen_string_literal: true

require 'csv'

module Tasks
  class VehiclesGenerator
    class << self
      def call!
        sleep(2)

        CSV.foreach('././db/migrate/data/vehicles.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Vehicle.create!(license_plate: to_hash['license_plate'],
                          name: to_hash['name'],
                          color: to_hash['color'],
            status: Status.find_by_name('ativo'))

          puts "--- Vehicle #{to_hash['license_plate']} created!"
        end

        puts "-- #{Vehicle.count} vehicles created!"
      end
    end
  end
end
