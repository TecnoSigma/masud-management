require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Vehicle and Status' do
      vehicle = Vehicle.new

      expect(vehicle).to respond_to(:status)
    end
  end
end
