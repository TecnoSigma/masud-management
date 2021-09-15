require 'rails_helper'

RSpec.describe Builders::Payloads::Payment::CreateSubscriber do
  describe '.data' do
    it 'returns subscriber payload when pass a company' do
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

      expected_result = { birthdate_day: Subscriber.birthdate_day(Date.yesterday),
                          birthdate_month: Subscriber.birthdate_month(Date.yesterday),
                          birthdate_year: Subscriber.birthdate_year(Date.yesterday),
                          code: "subscriber-97445877995296",
                          cpf: "60286685534",
                          email: "cletus@cronin.co",
                          fullname: "Dra. Carlos Eduardo Martins",
                          phone_area_code: "31",
                          phone_number: "64864806",
                          address: { city: "Tupãssi",
                                     complement: "sobreloja",
                                     country: "BRA",
                                     district: "Sítio do Quinto",
                                     number: 100,
                                     state: "RR",
                                     street: "Rodovia Luiz",
                                     zipcode: "11975931"},
                          billing_info: { credit_card: { expiration_month: "06",
                                                         expiration_year: "40",
                                                         holder_name: "JOAO F DA SILVA",
                                                         number: "5484788254314887" } } }

      expect(described_class.data(subscriber_data, credit_card_data)).to eq(expected_result)
    end

    it 'returns subscriber payload when not pass a company' do
      subscriber_data = {'code'=>"subscriber-20053436425154",
                         'name'=>"Dr. Sophia da Rocha",
                         'responsible_name'=>"Dra. Carlos Eduardo Martins",
                         'responsible_cpf'=>"602.866.855-34",
                         'document'=>"602.866.855-34",
                         'kind'=>"PF",
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

      expected_result = { birthdate_day: Subscriber.birthdate_day(Date.yesterday),
                          birthdate_month: Subscriber.birthdate_month(Date.yesterday),
                          birthdate_year: Subscriber.birthdate_year(Date.yesterday),
                          code: "subscriber-60286685534",
                          cpf: "60286685534",
                          email: "cletus@cronin.co",
                          fullname: "Dra. Carlos Eduardo Martins",
                          phone_area_code: "31",
                          phone_number: "64864806",
                          address: { city: "Tupãssi",
                                     complement: "sobreloja",
                                     country: "BRA",
                                     district: "Sítio do Quinto",
                                     number: 100,
                                     state: "RR",
                                     street: "Rodovia Luiz",
                                     zipcode: "11975931"},
                          billing_info: { credit_card: { expiration_month: "06",
                                                         expiration_year: "40",
                                                         holder_name: "JOAO F DA SILVA",
                                                         number: "5484788254314887" } } }

      expect(described_class.data(subscriber_data, credit_card_data)).to eq(expected_result)
    end
  end
end
