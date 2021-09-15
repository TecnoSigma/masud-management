require 'rails_helper'

RSpec.describe Gateways::Payment::Subscriber do
  describe '.create' do
    it 'creates a new subscriber in gateway company when pass valid data' do
      response = double()

      allow(response).to receive(:code) { 201 }
      allow(RestClient::Request).to receive(:execute) { response }

      subscriber_data = {'code'=>"subscriber-20053436425154",
                         'name'=>"Dr. Sophia da Rocha",
                         'responsible_name'=>"Dra. Carlos Eduardo Martins",
                         'responsible_cpf'=>"602.866.855-34",
                         'document'=>"97.445.877/9952-96",
                         'kind'=>"PJ",
                         'address'=>"Rodovia Luiz",
                         'number'=>100,
                         'complement'=>"sobreloja",
                         'district'=>"Sítio do Quinto",
                         'city'=>"Tupãssi",
                         'state'=>"Roraima",
                         'postal_code'=>"11975-931",
                         'ip'=>"113.183.94.122",
                         'email'=>"cletus@cronin.co",
                         'telephone'=>"(31) 6486 4806",
                         'cellphone'=>"(51) 9 9861 7835",
                         'user'=>"alyciamayer",
                         'password'=>"1c19AfIkJqZnOaVt",
                         'status'=>"pendente",
                         'deleted_at'=>nil}

      credit_card_data = { 'payment_method'=> 'Cartão de Crédito' ,
                           'credit_card_number'=> '5484788254314887',
                           'expiration_month'=> '06',
                           'expiration_year'=> '2040',
                           'holder_name'=> 'JOAO F DA SILVA' }

      expected_result = { status_code: 201, subscriber_code: 'subscriber-97445877995296' }

      result = described_class.create(subscriber_data, credit_card_data)

      expect(result).to eq(expected_result)
    end

    it 'no creates a new subscriber in gateway company when pass invalid data' do
      response = double()

      allow(response).to receive(:code) { 500 }
      allow(RestClient::Request).to receive(:execute) { response }

      subscriber_data = {'code'=>"subscriber-20053436425154",
                         'name'=>"Dr. Sophia da Rocha",
                         'responsible_name'=>"Dra. Carlos Eduardo Martins",
                         'responsible_cpf'=>"602.866.855-34",
                         'document'=>"97.445.877/9952-96",
                         'kind'=>"PJ",
                         'address'=>"Rodovia Luiz",
                         'number'=>100,
                         'complement'=>"sobreloja",
                         'district'=>"Sítio do Quinto",
                         'city'=>"Tupãssi",
                         'state'=>"Roraima",
                         'postal_code'=>"11975-931",
                         'ip'=>"113.183.94.122",
                         'email'=>"cletus@cronin.co",
                         'telephone'=>"(31) 6486 4806",
                         'cellphone'=>"(51) 9 9861 7835",
                         'user'=>"alyciamayer",
                         'password'=>"1c19AfIkJqZnOaVt",
                         'status'=>"pendente",
                         'deleted_at'=>nil}

      credit_card_data = { 'payment_method'=> 'Cartão de Crédito' ,
                           'credit_card_number'=> '5484788254314887',
                           'expiration_month'=> '06',
                           'expiration_year'=> '2040',
                           'holder_name'=> 'JOAO F DA SILVA' }

      expected_result = { status_code: 500, subscriber_code: 'subscriber-97445877995296' }

      result = described_class.create(subscriber_data, credit_card_data)

      expect(result).to eq(expected_result)
    end
  end

  describe '.update!' do
    it 'updates subscriber data in gateway company when pass valid data' do
      subscriber = FactoryBot.create(:subscriber)

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(RestClient::Request).to receive(:execute) { response }
 

      subscriber_data = { 'code'=>"subscriber-63425019802275",
                          'email'=>"nana@deckowruecker.net",
                          'fullname'=>"Miss Morton Goodwin",
                          'cpf'=>"39206070290",
                          'phone_area_code'=>"88",
                          'phone_number'=>"70759574",
                          'birthdate_day'=>1,
                          'birthdate_month'=>8,
                          'birthdate_year'=>2020,
                          'address'=>
                          { 'street'=>"Matthew Crescent",
                            'number'=>"66",
                            'complement'=>"fundos",
                            'district'=>"West Carolborough",
                            'city'=>"Anitraville",
                            'state'=>"RJ",
                            'country'=>"BRA",
                            'zipcode'=>"55301700" } }

      result = described_class.update!(subscriber)

      expect(result).to eq(true)
    end


    it 'no updates subscriber data in gateway company when pass invalid data' do
      subscriber = FactoryBot.create(:subscriber)

      response = double()

      allow(response).to receive(:code) { 400 }
      allow(RestClient::Request).to receive(:execute) { response }

      subscriber_data = { 'code'=>"subscriber-63425019802275",
                          'email'=>"nana@deckowruecker.net",
                          'fullname'=>"Miss Morton Goodwin",
                          'cpf'=>"39206070290",
                          'phone_area_code'=>"88",
                          'phone_number'=>"70759574",
                          'birthdate_day'=>1,
                          'birthdate_month'=>8,
                          'birthdate_year'=>2020,
                          'address'=>
                          { 'street'=>"Matthew Crescent",
                            'number'=>"66",
                            'complement'=>"fundos",
                            'district'=>"West Carolborough",
                            'city'=>"Anitraville",
                            'state'=>"RJ",
                            'country'=>"BRA",
                            'zipcode'=>"55301700" } }

      result = described_class.update!(subscriber)

      expect(result).to eq(false)
    end
  end
end
