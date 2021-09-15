# frozen_string_literal: true

module Gateways
  module Payment
    module Subscriber
      class << self
        def create(subscriber_data, payment_data)
          subscriber_attributes = Builders::Payloads::CreateSubscriber
                                    .data(subscriber_data, payment_data)

          if subscriber?(subscriber_attributes[:code])
            { status_code: Rack::Utils::HTTP_STATUS_CODES.key('OK'),
              subscriber_code: subscriber_attributes[:code] }
          else
            response = RestClient::Request
                         .execute(method: :post,
                                  url: "#{ENV['MOIP_URL']}/assinaturas/v1/customers?new_vault=true",
                                  payload: subscriber_attributes.to_json,
                                  headers: { 'Content-Type' => 'application/json',
                                             'Authorization' => "Basic #{ENV['MOIP_BASE64']}" })

            { status_code: response.code, subscriber_code: subscriber_attributes[:code] }
          end
        end

        def update!(subscriber_data)
          subscriber_attributes = Builders::Payloads::UpdateSubscriber.data(subscriber_data)

          response = RestClient::Request
                       .execute(method: :put,
                                url: "#{ENV['MOIP_URL']}/assinaturas/v1/customers/#{subscriber_data.code}",
                                payload: subscriber_attributes.to_json,
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "Basic #{ENV['MOIP_BASE64']}" })

          response.code == Rack::Utils::SYMBOL_TO_STATUS_CODE[:ok]
        end

        def subscriber?(subscriber_code)
          response = RestClient::Request
                       .execute(method: :get,
                                url: "#{ENV['MOIP_URL']}/assinaturas/v1/customers/#{subscriber_code}",
                                headers: { 'Content-Type' => 'application/json',
                                           'Authorization' => "Basic #{ENV['MOIP_BASE64']}" })

          response.code == Rack::Utils::HTTP_STATUS_CODES.key('OK')
        rescue => e
          Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

          false
        end
      end
    end
  end
end
