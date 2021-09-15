module Builders
  module Payloads
    module CreateSubscription
      class << self
        def data(plan_code:, amount_payable:, subscriber_code:, payment_method:)
          { code: Subscription.code,
            amount: convert_to_cents(amount_payable),
            payment_method: Subscription.payment_method(payment_method),
            plan: { code: plan_code },
            customer: { code: subscriber_code } }
        end

        def convert_to_cents(value)
          (value.to_f * 100).to_i
        end
      end

      private_class_method :convert_to_cents
    end
  end
end

