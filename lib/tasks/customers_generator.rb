# frozen_string_literal: true

require 'csv'

module Tasks
  class CustomersGenerator
    class << self
      def call!
        sleep(2)

        CSV.foreach('././db/migrate/data/customers.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Customer.create(company: to_hash['company'],
            cnpj: to_hash['cnpj'],
            email: to_hash['email'],
            secondary_email: to_hash['secondary_email'],
            tertiary_email: to_hash['tertiary_email'],
            telephone: to_hash['telephone'],
            password: Customer::DEFAULT_PASSWORD,
            status: Status.find_by_name('ativo'))

          puts "--- Customer #{to_hash['company']} created!"
        end

        puts "-- #{Customer.count} customers created!"
      end
    end
  end
end
