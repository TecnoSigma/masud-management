require 'rails_helper'

RSpec.describe Tributes::Irrf do
  describe '.employee' do
    it 'calculates employee IRRF value when limit is tread of first aliquot' do
      result = described_class.employee(0.0)

      expect(result).to eq(0.00)
    end

    it 'calculates employee IRRF value when limit is inside of aliquots' do
      result = described_class.employee(5_000.0)

      expect(result).to eq(331.37)
    end

    it 'calculates employee IRRF value when limit is greater than last aliquot' do
      result = described_class.employee(30_000.0)

      expect(result).to eq(7145.75)
    end
  end
end
