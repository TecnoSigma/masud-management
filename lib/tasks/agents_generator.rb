# frozen_string_literal: true

require 'csv'

module Tasks
  class AgentsGenerator
    class << self
      def call!
        sleep(2)

        CSV.foreach('././db/migrate/data/agents.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Agent.create!(name: to_hash['name'],
            admission_date: to_hash['admission_date'].to_date,
            codename: to_hash['codename'],
            cvn_number: to_hash['cvn_number'],
            cvn_validation_date: to_hash['cvn_validation_date'].to_date,
            rg: to_hash['rg'],
            cpf: to_hash['cpf'],
            status: Status.find_by_name('ativo'),
            profiles: [Profile.find_by_kind('agent')])

          puts "--- Agent #{to_hash['codename']} created!"
        end

        puts "-- #{Agent.count} agents created!"
      end
    end
  end
end
