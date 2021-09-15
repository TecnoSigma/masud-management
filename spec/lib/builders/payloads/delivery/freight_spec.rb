require 'rails_helper'

RSpec.describe Builders::Payloads::Delivery::Freight do
  describe '.data' do
    it 'returns delivery freight payload' do
      postal_code = '12345-909'
      price = 123.55

      result = described_class.data(destiny_postal_code: postal_code, price: price)
      expected_result = { frete:
                          [ { cepdes: "12345909",
                              cepori: "04842110",
                              cnpj: "12345678901234",
                              conta: "000001",
                              contrato: "123",
                              frap: "Nao",
                              modalidade: 3,
                              peso: 0.1,
                              tpentrega: "D",
                              tpseguro: "N",
                              vlcoleta: 0.0,
                              vldeclarado: 123.55 }
                          ]
                        }

      expect(result).to eq(expected_result)
    end
  end
end
