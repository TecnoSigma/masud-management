require 'rails_helper'

RSpec.describe DriverHelper, type: :helper do
  include DriverHelper

  describe '#rate' do
    it 'returns driver rate' do
      driver = FactoryBot.create(:driver)
      rating = FactoryBot.create(:rating, rate: 8.0, driver: driver)

      expect(helper.rate(driver)).to eq('8.0/10.0')
    end 
  end 
end
