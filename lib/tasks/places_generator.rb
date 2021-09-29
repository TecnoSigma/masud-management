# frozen_string_literal: true

module Tasks
  class PlacesGenerator
    class << self
      PLACES_API = 'https://servicodados.ibge.gov.br/api'
      TABLES_LIST = %w[states cities].freeze
      DF_ADMIN_REGIONS = [
        'Águas Claras',
        'Arniqueira',
        'Brazlândia',
        'Candangolândia',
        'Ceilândia',
        'Cruzeiro',
        'Fercal',
        'Gama',
        'Guará',
        'Itapoã',
        'Jardim Botânico',
        'Lago Norte',
        'Lago Sul',
        'Núcleo Bandeirante',
        'Paranoá',
        'Park Way',
        'Planaltina',
        'Plano Piloto',
        'Recanto das Emas'].freeze


      private_constant :DF_ADMIN_REGIONS, :PLACES_API, :TABLES_LIST

      def call!
        raise PlacesGenerationError if states.body == '[]'

        clear_tables!
        wait
        generate_states!
        wait
        generate_cities!
        wait
        generate_admin_regions!

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
            .map { |city| remove_accents(city['nome']).gsub('-',' ') }
                   .sort

          cities.each do |city|
            City.create(name: city, state: state)

            puts "--- City of #{city} created!"
          end
        end

        puts "-- #{City.count} cities created!"

        true
      end

      def generate_admin_regions!
        federal_district = State.find_by_name('Distrito Federal')

        DF_ADMIN_REGIONS.each do |region|
          formatted_region = remove_accents(region).gsub('-',' ')

          City.create(name: formatted_region, state: federal_district)

          puts "--- Admin Region of #{formatted_region} created!"
        end

        puts "-- #{DF_ADMIN_REGIONS.count} admin regions created!"
      end

      def states
        @states ||= get('v1/localidades/estados')
      end

      def wait
        sleep(2)
      end

      def remove_accents(string)
        accents = {
          ['á','à','â','ä','ã'] => 'a',
          ['Ã','Ä','Â','À','Á'] => 'A',
          ['é','è','ê','ë'] => 'e',
          ['Ë','É','È','Ê'] => 'E',
          ['í','ì','î','ï'] => 'i',
          ['Î','Ì'] => 'I',
          ['ó','ò','ô','ö','õ'] => 'o',
          ['Õ','Ö','Ô','Ò','Ó'] => 'O',
          ['ú','ù','û','ü'] => 'u',
          ['Ú','Û','Ù','Ü'] => 'U',
          ['ç'] => 'c', ['Ç'] => 'C',
          ['ñ'] => 'n', ['Ñ'] => 'N'
        }

        accents.each do |accent,rep|
          accent.each do |letter|
            string = string.gsub(letter, rep)
          end
        end

        string = string.gsub(/[^a-zA-Z0-9\. ]/,"")
        string = string.gsub(/[ ]+/," ")
        string = string.gsub(/ /,"-")
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
