class SubscriptionCancellationJob < ApplicationJob
  def perform(subscriber_code:, by_company: false)
    raise SubscriptionFoundError unless Subscription.find_by_code(subscriber_code)

    response = Gateways::Payment::Subscription.cancellation(subscriber_code)

    if response.code == Rack::Utils::HTTP_STATUS_CODES.key('OK')
      subscription = Subscription.find_by_code(subscriber_code)

      new_status = by_company ?
                     Status::STATUSES[:cancelled_by_company] :
                     Status::STATUSES[:cancelled_by_subscriber]

      subscription.update_attributes!(status: new_status)

      Rails.logger.info("Assinatura [#{subscription_code}] cancelada com sucesso!")

      return true
    end
    
    false
  rescue StandardError, SubscriptionFoundError => e
    error_message = "Subscription Code: #{subscriber_code} - " \
                    "Message: #{e.message} - " \
                    "Backtrace: #{e.backtrace}"

    Rails.logger.error(error_message)

    false
  end
end
