module Gateways
  module Delivery
    class Freight
      class << self
        def calculate(postal_code:, price:, quantity:)
          payload = Builders::Payloads::Delivery::Freight
                      .data(destiny_postal_code: postal_code, price: price, quantity: quantity)

          response = RestClient::Request
                       .execute(method: :post,
                                url: ENV['JADLOG_FREIGHT_URL'],
                                payload: payload.to_json,
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "Bearer #{ENV['JADLOG_TOKEN']}" })

          parsed_response = JSON.parse(response.body).deep_symbolize_keys

          if parsed_response[:error]
            raise CollectFreightValueError
          else
            parsed_response
          end
        rescue CollectFreightValueError => e
          Rails.logger.error("#{e.message}")

          {}
        end
      end
    end
  end
end
