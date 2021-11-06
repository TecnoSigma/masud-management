# frozen_string_literal: true

require 'csv'

module Tasks
  class TeamsGenerator
    class << self
      def call!
        sleep(2)

        for number in 1..Team::MAXIMUM_QUANTITY
          team_number = "%02d" % number
          team_name = "#{Team::PREFIX}-#{team_number}"

          Team.create!(name: team_name)

          puts "--- Team #{team_name} created!"
        end

        puts "-- #{Team.count} teams created!"
      end
    end
  end
end
