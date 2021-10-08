# frozen_string_literal: true

module ApplicationHelper
  def first_name(token, type)
    denomination = case type
                   when :employee
                     :name
                   when :customer
                     :company
                   end

    ServiceToken.find_by_token(token).send(type).send(denomination).split.first
  end

  def first_customer_name(customer)
    customer.split.first
  end

  def convert_date_time(date_time)
    DateTime.parse(date_time.to_s).strftime('%d/%m/%Y - %H:%M')
  end

  def order_color(order)
    return 'scheduled-order' if order.scheduled?
    return 'confirmed-order' if order.confirmed?
    return 'refused-order' if order.refused?
  end
end
