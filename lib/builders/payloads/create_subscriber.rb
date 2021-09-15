# frozen_string_literal: true

module Builders
  module Payloads
    module CreateSubscriber
      class << self
        def data(subscriber_data, credit_card_data)
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
                       zipcode: Subscriber.postal_code(subscriber_data['postal_code']) },
            billing_info: credit_card_info(credit_card_data) }
        end

        def credit_card_info(payment_data)
          { credit_card: { holder_name: Subscriber.holder_name(payment_data['holder_name']),
                           number: Subscriber.credit_card_number(payment_data['credit_card_number']),
                           expiration_month: Subscriber.expiration_month(payment_data['expiration_month']),
                           expiration_year: Subscriber.expiration_year(payment_data['expiration_year']) } } 
        end
      end
    end
  end
end
