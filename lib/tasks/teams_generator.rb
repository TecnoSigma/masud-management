# frozen_string_literal: true

require 'csv'

module Tasks
  class TeamsGenerator
    class << self
      def call!
        sleep(2)

        CSV.foreach('././db/migrate/data/teams.csv', headers: true).map do |row|
          to_hash = row.to_hash

          Team.create!(name: to_hash['name'])

          puts "--- Team #{to_hash['name']} created!"
        end

        puts "-- #{Team.count} teams created!"
      end
    end
  end
end
