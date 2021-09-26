# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ServiceToken, type: :model do
  describe 'validates relationships' do
    it 'validates optinal relationship (1:1) between ServiceToken and Customer' do
      service_token = ServiceToken.new

      expect(service_token).to respond_to(:customer)
    end

    it 'validates optinal relationship (1:1) between ServiceToken and Employee' do
      service_token = ServiceToken.new

      expect(service_token).to respond_to(:employee)
    end
  end

  describe 'validates presences' do
    it 'of token' do
      service_token = FactoryBot.build(:service_token, token: nil)

      expect(service_token).to be_invalid
    end
  end
end
