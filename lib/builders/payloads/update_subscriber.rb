# frozen_string_literal: true                                                                                                                                                             

module Builders
  module Payloads
    module UpdateSubscriber
      class << self
        def data(subscriber_data)
          cpf = subscriber_data['kind'] == Subscriber::COMPANY ?
                  subscriber_data['responsible_cpf'] :
                  subscriber_data['document']

          { code: Subscriber.code(subscriber_data['document']),
            email: Subscriber.email(subscriber_data['email']),
            fullname: Subscriber.fullname(subscriber_data['responsible_name']),
            cpf: Subscriber.cpf(cpf),
            phone_area_code: Subscriber.phone_area_code(subscriber_data['telephone']),
            phone_number: Subscriber.phone_number(subscriber_data['telephone']),
            birthdate_day: Subscriber.birthdate_day(Date.yesterday),
            birthdate_month: Subscriber.birthdate_month(Date.yesterday),
            birthdate_year: Subscriber.birthdate_year(Date.yesterday),
            address: { street: Subscriber.street(subscriber_data['address']),
                       number: Subscriber.number(subscriber_data['number']),
                       complement: Subscriber.complement(subscriber_data['complement']),
                       district: Subscriber.district(subscriber_data['district']),
                       city: Subscriber.city(subscriber_data['city']),
                       state: Subscriber.state(subscriber_data['state']),
                       country: Subscriber::DEFAULT_COUNTRY,
                       zipcode: Subscriber.postal_code(subscriber_data['postal_code']) } }
        end
      end
    end
  end
end
