# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tasks::PlacesGenerator do
  describe '.call' do
    it 'call methods to create states and cities in database' do
      allow(described_class).to receive(:clear_tables!) { true }
      allow(described_class).to receive(:generate_states!) { true }
      allow(described_class).to receive(:generate_cities!) { true }

      result = described_class.call!

      expect(result).to eq(true)
    end

    it 'raises error when result body is empty' do
      states = double

      allow(states).to receive(:body) { '[]' }
      allow(described_class).to receive(:states) { states }

      expect { described_class.call! }.to raise_error(PlacesGenerationError)
    end
  end

  describe '.clear_tables' do
    it 'clean tables (States and Cities)' do
      state = FactoryBot.create(:state)
      FactoryBot.create(:city, state: state)

      described_class.send(:clear_tables!)

      result1 = State.count
      result2 = City.count

      expect(result1).to eq(0)
      expect(result2).to eq(0)
    end
  end

  describe '.generate_states!' do
    it 'creates states' do
      state1 = 'São Paulo'
      external_id1 = '22'

      state2 = 'Minas Gerais'
      external_id2 = '45'

      states_data = [
        { 'nome' => state1, 'id' => external_id1 },
        { 'nome' => state2, 'id' => external_id2 }
      ].to_json

      states = double

      allow(states).to receive(:body) { states_data }
      allow(described_class).to receive(:states) { states }

      described_class.send(:generate_states!)

      result1 = State.find_by_name(state1).name
      result2 = State.find_by_name(state2).name

      expect(result1).to eq(state1)
      expect(result2).to eq(state2)
    end
  end

  describe '.generate_cities!' do
    it 'creates cities' do
      city = 'Manaus'

      cities_data = [{ 'nome' => city }].to_json

      response = double


      allow(response).to receive(:body) { cities_data }
      allow(described_class).to receive(:get) { response }

      state = FactoryBot.create(:state)

      described_class.send(:generate_cities!)

      result = State.find_by_name(state.name).cities.first.name

      expect(result).to eq(city)
    end
  end
end
