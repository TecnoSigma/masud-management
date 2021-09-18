require 'rails_helper'

RSpec.describe State, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:N) between State and Cities' do
      state = State.new

      expect(state).to respond_to(:cities)
    end
  end

  describe 'validates numericality' do
    it 'no validates when external ID isn\'t integer' do
      state = FactoryBot.build(:state, external_id: 12.5)

      expect(state).to be_invalid
    end

    it 'no validates when external ID is less than one' do
      state = FactoryBot.build(:state, external_id: -12)

      expect(state).to be_invalid
    end
  end

  describe 'validates presences' do
    it 'of name' do
      state = FactoryBot.build(:state, name: nil)

      expect(state).to be_invalid
    end

    it 'of external_id' do
      state = FactoryBot.build(:state, external_id: nil)

      expect(state).to be_invalid
    end
  end
end
