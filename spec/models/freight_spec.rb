require 'rails_helper'

RSpec.describe Freight do
  describe '.cnpj' do
    it 'returns formatted CNPJ to usage in delivery payload' do
      formatted_cnpj = '12345678901234'

      result = described_class.cnpj

      expect(result).to eq(formatted_cnpj)
    end
  end

  describe '.postal_code' do
    it 'returns formatted postal code to usage in delivery payload' do
      formatted_postal_code = '04842110'

      result = described_class.postal_code

      expect(result).to eq(formatted_postal_code)
    end
  end

  describe '.calculate' do
    it 'calculates freight to send cam' do
      postal_code = '04842100'
      price = 100.0
      quantity = 1
      freight_data  = {:frete=>
                       [{:cepdes=>postal_code,
                         :cepori=>"04842110",
                         :cnpj=>"12345678901234",
                         :conta=>"000001",
                         :contrato=>"123",
                         :frap=>"Nao",
                         :modalidade=>3,
                         :peso=>13.78,
                         :prazo=>5,
                         :tpentrega=>"D",
                         :tpseguro=>"N",
                         :vlcoleta=>0.0,
                         :vldeclarado=>100.0,
                         :vltotal=>78.26}]}

      allow(Gateways::Delivery::Freight).to receive(:calculate) { freight_data }

      expect(described_class.calculate(postal_code: postal_code, price: price, quantity: quantity)).to eq('23.48')
    end

    it 'returns zeroed value then occurs some errors' do
      postal_code = '04842100'
      price = 100.0
      quantity = 1

      allow(Gateways::Delivery::Freight).to receive(:calculate) { raise StandardError }

      expect(described_class.calculate(postal_code: postal_code, price: price, quantity: quantity)).to eq('0.00')
    end
  end
end
