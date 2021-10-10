# frozen_string_literal: true

module OrdersHelper
  def order_link(order_number)
    order_type = Order.find_by_order_number(order_number).type

    type = if Order.children.include?(order_type)
             'escolta'
           else
             ''
           end

    link_to(order_number, "/gestao/admin/dashboard/#{type}/#{order_number}").html_safe
  end
end
