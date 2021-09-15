require 'rails_helper'

RSpec.describe VehicleModel, type: :model do
  describe 'validate relationships' do
    it 'validate relationship (N:1) between VehicleBrand and VehicleModel' do
      vehicle_model = VehicleModel.new

      expect(vehicle_model).to respond_to(:vehicle_brand)
    end
  end
end
