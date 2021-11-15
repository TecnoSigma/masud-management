# frozen_string_literal: true

require 'csv'

module Tasks
  class ArsenalsGenerator
    class << self
      def call!
        create_guns!
        create_munitions!
      end

      def create_guns!
        sleep(2)

        CSV.foreach('././db/migrate/data/guns.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Gun.create!(number: to_hash['number'],
                      kind: to_hash['kind'].downcase,
                      caliber: to_hash['caliber'].to_s,
                      sinarm: to_hash['sinarm'].to_s,
                      situation: to_hash['situation'].downcase,
                      registration_validity: to_hash['registration_validity'].to_date,
                      status: Status.find_by_name('ativo'))

          puts "--- Gun #{to_hash['number']} created!"
        end

        puts "-- #{Gun.count} guns created!"
      end

      def create_munitions!
        sleep(2)

        CSV.foreach('././db/migrate/data/munitions.csv', headers: true).map do |row|
          to_hash = row.to_hash

          MunitionStock.create!(caliber: to_hash['kind'],
                                quantity: to_hash['quantity'].to_i,
                                last_update: DateTime.now)

          puts "--- Munition #{to_hash['kind']} created!"
        end

        puts "-- #{MunitionStock.count} munitions created!"
      end
    end

    private_class_method :create_guns!, :create_munitions!
  end
end
