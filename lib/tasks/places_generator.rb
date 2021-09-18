# frozen_string_literal: true

module Tasks
  class PlacesGenerator
    class << self
      PLACES_API = 'https://servicodados.ibge.gov.br/api'
      TABLES_LIST = %w[states cities].freeze

      private_constant :PLACES_API, :TABLES_LIST

      def call!
        raise PlacesGenerationError if states.body == '[]'

        clear_tables!
        wait
        generate_states!
        wait
        generate_cities!

        true
      end

      def clear_tables!
        State.destroy_all

        TABLES_LIST.each do |place|
          ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{place} RESTART IDENTITY;")

          puts "--- #{place} table deleted!"
        end

        puts "-- #{TABLES_LIST.count} tables created!"

        true
      end

      def generate_states!
        states_list = JSON
                      .parse(states.body)
                      .map { |state| [state['nome'], state['id']] }
                      .sort { |a, b| a <=> b }

        states_list.each do |state|
          State.create!(name: state.first, external_id: state.last)

          puts "--- State of #{state.first} created!"
        end

        puts "-- #{State.count} states created!"

        true
      end

      def generate_cities!
        State.all.each do |state|
          response = get("v1/localidades/estados/#{state.external_id}/municipios")

          next unless response.respond_to?(:body) || response.body != '[]'

          cities = JSON
                   .parse(response.body)
                   .map { |city| city['nome'] }
                   .sort

          cities.each do |city|
            City.create(name: city, state: state)

            puts "--- City of #{city} created!"
          end
        end

        puts "-- #{City.count} cities created!"

        true
      end

      def states
        @states ||= get('v1/localidades/estados')
      end

      def wait
        sleep(2)
      end

      def get(source)
        RestClient.get("#{PLACES_API}/#{source}")
      rescue SocketError, Errno::ECONNREFUSED => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        '[]'
      end
    end

    private_class_method :wait,
                         :states,
                         :clear_tables!,
                         :generate_states!,
                         :generate_cities!,
                         :get
  end
end
