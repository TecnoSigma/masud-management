# frozen_string_literal: true

module Gateways
  module Payment
    module Subscription
      class << self
        attr_accessor :code, :body

        def create(plan_code:, amount_payable:, subscriber_code:, payment_method:)
          subscription_attributes = Builders::Payloads::CreateSubscription
                                      .data(plan_code: plan_code,
                                            amount_payable: amount_payable,
                                            subscriber_code: subscriber_code,
                                            payment_method: payment_method)

          response = call(action: '?new_customer=false',
                          method: :post,
                          payload: subscription_attributes.to_json)

          { status_code: response.code, subscription_code: subscription_attributes[:code] }
        end

        def update_recurrence(subscription_code:, amount_payable:)
          payload = Builders::Payloads::UpdateSubscription
                      .data(subscription_code: subscription_code,
                            amount_payable: amount_payable)

          response = call(subscription_code: subscription_code, payload: payload.to_json, method: :put)

          response.code == Rack::Utils::HTTP_STATUS_CODES.key('OK') &&
            JSON.parse(response.body).fetch('errors').empty?
        end

        def find(subscription_code)
          call(subscription_code: subscription_code, method: :get)
        end

        def deactivation(subscription_code)
          call(subscription_code: subscription_code, action: '/suspend', method: :put)
        end

        def reactivation(subscription_code)
          call(subscription_code: subscription_code, action: '/activate', method: :put)
        end

        def cancellation(subscription_code)
          call(subscription_code: subscription_code, action: '/cancel', method: :put)
        end

        def call(subscription_code: '', action: '', payload: "{}", method:)
          url = "#{ENV['MOIP_URL']}/assinaturas/v1/subscriptions/#{subscription_code + action}"

          RestClient::Request.execute(method: method,
                                      url: url,
                                      payload: payload,
                                      headers: { 'Content-Type' => 'application/json',
                                      'Authorization' => "Basic #{ENV['MOIP_BASE64']}" })
        rescue => e
          Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

          response = self
          response.code = Rack::Utils::HTTP_STATUS_CODES.key('Internal Server Error')
          response.body = ''

          response
        end
      end
    end
  end
end
