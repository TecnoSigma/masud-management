# frozen_string_literal: true

class OrdersManagementPresenter
  def self.available_items(type, caliber = nil)
    return [Vehicle::MAXIMUM_QUANTITY] if type == :vehicle

    available_quantity = case type
                         when :gun       then Gun.available(caliber)
                         when :munition  then MunitionStock.find_by_caliber(caliber).try(:quantity)
                         else                 Tackle.available(type.to_s)
                         end

    return [] unless available_quantity

    (0..available_quantity).to_a
  end

  def self.available_agents
    available_quantity = Agent.available.count

    return [] if available_quantity.zero?

    (0..available_quantity).to_a
  end
end
