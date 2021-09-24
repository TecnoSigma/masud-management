# frozen_string_literal: true

require 'csv'

module Tasks
  class TacklesGenerator
    class << self
      def call!
        sleep(2)

        for serial_number in 1..70
          Radio.create!(
            serial_number: serial_number.to_s,
            status: Status.find_by_name('ativo'))

          puts "--- Radio #{serial_number} created!"
        end

        puts "-- #{Radio.count} radios created!"
      end
    end
  end
end
