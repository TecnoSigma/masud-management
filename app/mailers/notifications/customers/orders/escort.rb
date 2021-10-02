# frozen_string_literal: true

class Notifications::Customers::Orders::Escort < ApplicationMailer
  def scheduling(order_number:, email:)
    @greeting = Greeting.greet
    @order_number = order_number

    attachments.inline['logotype.jpeg'] = {
      data: File.read(Rails.root.join('app/assets/images/logotype.jpeg')),
      mime_type: 'image/jpeg'
    }

    mail to: email,
         subject: t('notifications.customer.orders.escort.scheduling.subject',
                    order_number: order_number)
  end
end
