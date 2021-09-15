require 'rails_helper'

RSpec.describe Builders::Payloads::UpdateSubscriber do
  describe '.data' do
    it 'returns subscriber payload when pass a company' do
      subscriber = FactoryBot.create(:subscriber, kind: 'PF')

      expected_result = { code: Subscriber.code(subscriber.document),
                          email: Subscriber.email(subscriber.email),
                          fullname: Subscriber.fullname(subscriber.responsible_name),
                          cpf: Subscriber.cpf(subscriber.document),
                          phone_area_code: Subscriber.phone_area_code(subscriber.telephone),
                          phone_number: Subscriber.phone_number(subscriber.telephone),
                          birthdate_day: Subscriber.birthdate_day(Date.yesterday),
                          birthdate_month: Subscriber.birthdate_month(Date.yesterday),
                          birthdate_year: Subscriber.birthdate_year(Date.yesterday),
                          address: { street: subscriber.address,
                                     number: subscriber.number,
                                     complement: subscriber.complement,
                                     district: subscriber.district,
                                     city: subscriber.city,
                                     state: Subscriber.state(subscriber.state),
                                     country: 'BRA',
                                     zipcode: Subscriber.postal_code(subscriber.postal_code) } }

      expect(described_class.data(subscriber)).to eq(expected_result)
    end
  end
end
