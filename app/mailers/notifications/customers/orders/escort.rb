# frozen_string_literal: true

module Notifications
  module Customers
    module Orders
      class Escort < ApplicationMailer
        def scheduling(order_number:, email:)
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
    end
  end
end
