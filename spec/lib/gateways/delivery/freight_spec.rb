require 'rails_helper'

RSpec.describe Gateways::Delivery::Freight do
  describe '.calculate' do
    it 'returns freight value when pass valid payload' do
      postal_code = '05707001'
      price = 100.0
      quantity = 2
      payload = {:frete=>
                 [{:cepori=>"04842110",
                   :cepdes=>postal_code,
                   :frap=>"Nao",
                   :peso=>0.1,
                   :cnpj=>"12345678901234",
                   :conta=>"000001",
                   :contrato=>"123",
                   :modalidade=>3,
                   :tpentrega=>"D",
                   :tpseguro=>"N",
                   :vldeclarado=>price,
                   :vlcoleta=>0.0}]}

      body =  "{\"frete\":[{\"cepdes\":\"04842100\",\"cepori\":\"04842110\",\"cnpj\":\"12345678901234\",\"conta\":\"000001\",\"contrato\":\"123\",\"frap\":\"Nao\",\"modalidade\":3,\"peso\":13.78,\"prazo\":5,\"tpentrega\":\"D\",\"tpseguro\":\"N\",\"vlcoleta\":0.0,\"vldeclarado\":100.0,\"vltotal\":78.26}]}"

      allow(Builders::Payloads::Delivery::Freight).to receive(:data) { payload }

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(RestClient::Request).to receive(:execute) { response }

      expected_result = {:frete=>
                         [{:cepdes=>"04842100",
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


      result = described_class.calculate(postal_code: postal_code, price: price, quantity: quantity)

      expect(result).to eq(expected_result)
    end

    it 'does not return freight value when pass invalid params' do
      postal_code = '05707001'
      price = 100.0
      quantity = 0
      payload = {:frete=>
                 [{:cepori=>"04842110",
                   :cepdes=>postal_code,
                   :frap=>"Nao",
                   :peso=>13.78,
                   :cnpj=>"12345678901234",
                   :conta=>"000001",
                   :contrato=>"123",
                   :modalidade=>3,
                   :tpentrega=>"D",
                   :tpseguro=>"N",
                   :vldeclarado=>price,
                   :vlcoleta=>0.0}]}

      body =  "{\"error\":\"any error\",\"frete\":[{\"cepdes\":\"04842100\",\"cepori\":\"04842110\",\"cnpj\":\"12345678901234\",\"conta\":\"000001\",\"contrato\":\"123\",\"frap\":\"Nao\",\"modalidade\":3,\"peso\":13.78,\"prazo\":5,\"tpentrega\":\"D\",\"tpseguro\":\"N\",\"vlcoleta\":0.0,\"vldeclarado\":100.0,\"vltotal\":78.26}]}"

      allow(Builders::Payloads::Delivery::Freight).to receive(:data) { payload }

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(RestClient::Request).to receive(:execute) { response }

      expected_result = {:frete=>
                         [{:cepdes=>"04842100",
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


      result = described_class.calculate(postal_code: postal_code, price: price, quantity: quantity)

      expect(result).to eq({})
    end
  end
end
