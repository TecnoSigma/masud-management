class Notifications::Customers::Orders::Escort < ApplicationMailer
  def scheduling(customer:, escort:, email:)
    @company = customer.company

    mail to: email,
         subject: t('notifications.customer.orders.escort.scheduling.subject',
                    order_number: escort.order_number)
  end
end
