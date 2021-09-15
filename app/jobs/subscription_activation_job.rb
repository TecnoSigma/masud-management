class SubscriptionActivationJob < ApplicationJob
  queue_as :default

  def perform
    pendents_subscriptions = Subscription.pendents.pluck(:code)

    return nil if pendents_subscriptions.empty?

    pendents_subscriptions.each do |subscription_code|
      begin
        response = Gateways::Payment::Subscription.find(subscription_code)

        subscription_data = JSON.parse(response.body).deep_symbolize_keys

        if subscription_data.fetch(:status) == Status::PAYMENT_STATUSES[:activated]
          subscription = Subscription.find_by_code(subscription_code)
          subscriber = subscription.subscriber

          subscriber.update_attributes!(status: Status::STATUSES[:activated])
          subscription.update_attributes!(status: Status::STATUSES[:activated])

          Rails.logger.info("Assinatura [#{subscription_code}] ativada com sucesso!")
        end
      rescue => e
        error_message = "Subscription Code: #{subscription_code} - " \
                        "Message: #{e.message} - " \
                        "Backtrace: #{e.backtrace}"

        Rails.logger.error(error_message)
      end

      next
    end
  end
end
