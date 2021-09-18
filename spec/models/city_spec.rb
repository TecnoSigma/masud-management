# frozen_string_literal: true

require 'rails_helper'

RSpec.describe City, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between City and State' do
      city = City.new

      expect(city).to respond_to(:state)
    end
  end

  describe 'validates presences' do
    it 'of name' do
      city = FactoryBot.build(:city, name: nil)

      expect(city).to be_invalid
    end
  end
end
