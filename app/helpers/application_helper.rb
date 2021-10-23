# frozen_string_literal: true

module ApplicationHelper
  def boolean_options
    [[t('true'), true], [t('false'), false]]
  end

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

  def convert_date(date)
    return '' unless date.present?

    date.strftime('%d/%m/%Y')
  end

  def order_color(order)
    return 'scheduled-order' if order.scheduled?
    return 'confirmed-order' if order.confirmed?
    return 'refused-order' if order.refused?
  end

  def full_address(order, type)
    address = order.send("#{type}_address".to_sym)
    number = order.send("#{type}_number".to_sym)
    complement = order.send("#{type}_complement".to_sym)
    district = order.send("#{type}_district".to_sym)
    city = order.send("#{type}_city".to_sym)
    state = order.send("#{type}_state".to_sym)

    "#{address}, #{number} - #{district} - #{city} - #{state}"
  end

  def date_time(order)
    "#{order.job_day} - #{order.job_horary}"
  end

  def available_items(type, caliber = nil)
    klass = type.to_s.titleize.constantize
    available_quantity = caliber ? klass.available(caliber).count : klass.available.count

    (0..available_quantity).to_a
  end
end
