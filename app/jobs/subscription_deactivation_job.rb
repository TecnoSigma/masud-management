class SubscriptionDeactivationJob < ApplicationJob
  queue_as :default

  def perform
    activated_subscriptions = Subscription.activated.pluck(:code)

    return nil if activated_subscriptions.empty?

    activated_subscriptions.each do |subscription_code|
      begin
        response = Gateways::Payment::Subscription.find(subscription_code)

        subscription_data = JSON.parse(response.body).deep_symbolize_keys

        if subscription_data.fetch(:status) == Status::PAYMENT_STATUSES[:deactivated]
          subscription = Subscription.find_by_code(subscription_code)

          subscription.update_attributes!(status: Status::STATUSES[:deactivated])

          Rails.logger.info("Assinatura [#{subscription_code}] desativada com sucesso!")
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