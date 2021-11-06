# frozen_string_literal: true

class OrdersManagementPresenter
  def self.available_items(type, caliber = nil)
    available_quantity = case type
                         when :gun       then Gun.available(caliber)
                         when :munition  then Munition.find_by_kind(caliber).try(:available)
                         when :vehicle   then 1
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
