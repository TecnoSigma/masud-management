# frozen_string_literal: true

module Notifications
  class Order < ApplicationMailer
    def warn_about_blocking(order_number:, blocking_date:, employee_token:)
      @order_number =  order_number
      @blocking_date = blocking_date.strftime('%d/%m/%Y - %H:%M')
      @employee_name = employee_name(employee_token)

      attachments.inline['logotype.jpeg'] = {
        data: File.read(Rails.root.join('app/assets/images/logotype.jpeg')),
        mime_type: 'image/jpeg'
      }

      mail to: ENV['ADMIN_EMAIL'],
           subject: t('notifications.order.warn_about_blocking.subject', order_number: @order_number)
    end

    private

    def employee_name(employee_token)
      ServiceToken.find_by_token(employee_token).employee.name
    end
  end
end
