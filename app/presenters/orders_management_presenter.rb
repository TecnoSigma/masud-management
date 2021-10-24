# frozen_string_literal: true

class OrdersManagementPresenter
  def self.available_items(type, caliber = nil)
    available_quantity = case type
                         when :gun
                           Gun.available(caliber).count
                         when :munition
                           Munition.find_by_kind(caliber).try(:available)
                         else
                           type.to_s.titleize.constantize.available.count
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
