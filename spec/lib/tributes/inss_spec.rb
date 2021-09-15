require 'rails_helper'

RSpec.describe Tributes::Inss do
  describe '.employers' do
    it 'returns employer INSS' do
      result = described_class.employers(100.0)

      expect(result).to eq(20.0)
    end
  end

  describe '.employee' do
    it 'calculates employee INSS value when limit is tread of first aliquot' do
      result = described_class.employee(0.0)

      expect(result).to eq(0.0)
    end

    it 'calculates employee INSS value when limit is ceiling of first aliquot' do
      result = described_class.employee(1044.99)

      expect(result).to eq(78.37)
    end

    it 'calculates employee INSS value when limit is tread of second aliquot' do
      result = described_class.employee(1045.0)

      expect(result).to eq(94.05)
    end

    it 'calculates employee INSS value when limit is ceiling of second aliquot' do
      result = described_class.employee(2089.60)

      expect(result).to eq(188.06)
    end

    it 'calculates employee INSS value when limit is tread of third aliquot' do
      result = described_class.employee(2089.61)

      expect(result).to eq(250.75)
    end

    it 'calculates employee INSS value when limit is ceiling of third aliquot' do
      result = described_class.employee(3134.40)

      expect(result).to eq(376.13)
    end

    it 'calculates employee INSS value when limit is tread of forth aliquot' do
      result = described_class.employee(3134.41)

      expect(result).to eq(438.82)
    end

    it 'calculates employee INSS value when limit is ceiling of forth aliquot' do
      result = described_class.employee(6101.06)

      expect(result).to eq(854.15)
    end

    it 'calculates employee INSS value when limit is greater than ceiling of forth aliquot' do
      result = described_class.employee(10_000.0)

      expect(result).to eq(854.15)
    end
  end
end
