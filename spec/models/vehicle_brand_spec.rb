require 'rails_helper'

RSpec.describe VehicleBrand, type: :model do
  describe 'validate relationships' do
    it 'validate relationship (1:N) between VehicleModel and VehicleBrand' do
      vehicle_brand = VehicleBrand.new 

      expect(vehicle_brand).to respond_to(:vehicle_models)
    end
  end

  it 'returns active vehicle brands' do
    vehicle_brand_1 = FactoryBot.create(:vehicle_brand, brand: 'Volks')
    vehicle_brand_2 = FactoryBot.create(:vehicle_brand, brand: 'ND')

    result = VehicleBrand.actives

    expect(result).to eq([vehicle_brand_1])
  end
end
