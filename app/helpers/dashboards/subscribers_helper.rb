module Dashboards::SubscribersHelper
  def drivers_name(vehicle)
    vehicle
      .drivers
      .pluck(:name)
      .sort
      .join(' | ') 
  end
end
