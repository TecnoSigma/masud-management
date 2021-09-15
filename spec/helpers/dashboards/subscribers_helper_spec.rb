require 'rails_helper'

RSpec.describe Dashboards::SubscribersHelper, type: :helper do
  describe '#drivers_name' do
    it 'returns sorted drivers name' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver_1 = FactoryBot.create(:driver, name: 'Zulmira Barbosa', vehicles: [vehicle])
      driver_2 = FactoryBot.create(:driver, name: 'Ana Couto', vehicles: [vehicle])

      result = helper.drivers_name(vehicle)

      expect(result).to eq("#{driver_2.name} | #{driver_1.name}")
    end
  end
end
