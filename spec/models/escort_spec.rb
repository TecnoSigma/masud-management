require 'rails_helper'

RSpec.describe Escort, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Customer and Escort' do
      escort = Escort.new

      expect(escort).to respond_to(:customer)
    end

    it 'validates relationship (N:1) between Status and Escort' do
      escort = Escort.new

      expect(escort).to respond_to(:status)
    end
  end
end
