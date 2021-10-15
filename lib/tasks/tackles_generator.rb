# frozen_string_literal: true

require 'csv'

module Tasks
  class TacklesGenerator
    class << self
      def call!
        create_radios!
        create_waistcoats!
      end

      def create_radios!
        sleep(2)

        for serial_number in 1..70
          Radio.create!(
            serial_number: serial_number.to_s,
            situation: Status.find_by_name('regular').name,
            status: Status.find_by_name('ativo'))

          puts "--- Radio #{serial_number} created!"
        end

        puts "-- #{Radio.count} radios created!"
      end

      def create_waistcoats!
        sleep(2)

        CSV.foreach('././db/migrate/data/waistcoats.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Waistcoat.create!(serial_number: to_hash['serial_number'].to_s,
                            register_number: to_hash['register_number'].to_s,
                            brand: to_hash['brand'],
                            fabrication_date: to_hash['fabrication_date'].to_date,
                            validation_date: to_hash['validation_date'].to_date,
                            bond_date: to_hash['bond_date'].to_date,
                            protection_level: to_hash['protection_level'],
                            situation: to_hash['situation'],
                            status: status)

          puts "--- Waistcoat #{to_hash['serial_number']} created!"
        end

        puts "-- #{Waistcoat.count} waistcoats created!"
      end

      def status
        @status ||= Status.find_by_name('ativo')
      end
    end

    private_class_method :create_radios!, :create_waistcoats!, :status
  end
end
