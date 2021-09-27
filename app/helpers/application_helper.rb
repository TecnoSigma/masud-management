# frozen_string_literal: true

module ApplicationHelper
  def convert_date_time(date_time)
    DateTime.parse(date_time.to_s).strftime('%d/%m/%Y - %H:%M')
  end

  def order_color(order)
    return 'scheduled-order' if order.scheduled?
    return 'confirmed-order' if order.confirmed?
    return 'refused-order' if order.refused?
  end
end
