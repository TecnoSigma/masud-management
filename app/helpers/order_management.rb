# frozen_string_literal: true

module OrderManagementHelper
  def date_time(order)
    "#{order.job_day} - #{order.job_horary}"
  end
end
