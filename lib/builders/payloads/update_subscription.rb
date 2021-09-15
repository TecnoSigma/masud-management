module Builders
  module Payloads
    class UpdateSubscription
      class << self
        def data(subscription_code:, amount_payable:)
          next_invoice_date = find_next_invoice_date(subscription_code)

          {
            "plan":{
              "code": plan_code(subscription_code)
            },
            "amount": convert_to_cents(amount_payable).to_s,
            "next_invoice_date":{
              "day": next_invoice_date['day'].to_s,
              "month": next_invoice_date['month'].to_s,
              "year": next_invoice_date['year'].to_s
            }
          }
        end

        def find_next_invoice_date(subscription_code)
          subscription_data = Gateways::Payment::Subscription.call(subscription_code: subscription_code, method: :get)

          JSON.parse(subscription_data.body)['next_invoice_date']
        end

        def plan_code(subscription_code)
          subscription_data = Gateways::Payment::Subscription.call(subscription_code: subscription_code, method: :get)

          JSON.parse(subscription_data.body)['plan']['code']
        end

        def convert_to_cents(value)
          (value * 100.0).to_i
        end
      end

      private_class_method :find_next_invoice_date, :plan_code, :convert_to_cents
    end
  end
end
