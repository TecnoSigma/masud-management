# frozen_string_literal: true

module Services
  module Places
    class << self
      PLACES_API = 'https://servicodados.ibge.gov.br/api'.freeze

      private_constant :PLACES_API

      def states
        response = get('v1/localidades/estados')

        return response unless response.respond_to?(:body) || response.body == '[]'

        JSON
          .parse(response.body)
          .map { |state| [state['nome'], state['id']] }
          .sort { |a, b| a <=> b }
      end

      def cities(state_id)
        response = get("v1/localidades/estados/#{state_id}/municipios")

        return response unless response.respond_to?(:body) || response.body == '[]'

        JSON
          .parse(response.body)
          .map { |city| city['nome'] }
          .sort
      end

      def get(source)
        RestClient.get("#{PLACES_API}/#{source}")
      rescue SocketError, Errno::ECONNREFUSED => error
        Rails.logger.error("Message: #{error.massage} - Backtrace: #{error.backtrace}")

        []
      end
    end

    private_class_method :get
  end
end
