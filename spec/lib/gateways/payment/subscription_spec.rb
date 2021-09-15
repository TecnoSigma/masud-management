require 'rails_helper'

RSpec.describe Gateways::Payment::Subscription do
  describe '.create' do
    it 'creates a new subscription in gateway company when pass valid data' do
      uuid = 'abcde12345'
      response = double()

      allow(response).to receive(:code) { 201 }
      allow(SecureRandom).to receive(:uuid) { uuid }
      allow(RestClient::Request).to receive(:execute) { response }

      plan_code = 'standard-angels'
      subscriber_code = "subscriber-#{uuid}"
      amount_payable = 10.0
      payment_method = 'Cartão de Crédito'

      result = described_class.create(plan_code: plan_code, amount_payable: amount_payable, subscriber_code: subscriber_code, payment_method: payment_method)

      expected_result = { status_code: 201, subscription_code: "subscription-#{uuid}" }

      expect(result).to eq(expected_result)
    end

    it 'no creates a new subscription in gateway company when pass invalid data' do
      uuid = 'abcde12345'
      response = double()

      allow(response).to receive(:code) { 500 }
      allow(SecureRandom).to receive(:uuid) { uuid }
      allow(RestClient::Request).to receive(:execute) { response }

      plan_code = 'standard-angels'
      subscriber_code = "subscriber-#{uuid}"
      amount_payable = 10.0
      payment_method = 'Cartão de Crédito'

      result = described_class.create(plan_code: plan_code, amount_payable: amount_payable, subscriber_code: subscriber_code, payment_method: payment_method)

      expected_result = { status_code: 500, subscription_code: "subscription-#{uuid}" }

      expect(result).to eq(expected_result)
    end
  end

  describe '.find' do
    it 'finds subscription data of payment gateway' do
      subscription_code = 'subscription-7b7e868f-6a01-4808-a5f3-9c9d6ba3765e'
      subscription_data = {"amount"=>7990,
                           "code"=>subscription_code,
                           "moip_account"=>"MPA-7C15E835293E",
                           "id"=>"SUB-K9DHBUVY9RXX",
                           "creation_date"=>{"month"=>2, "hour"=>16, "year"=>2020, "day"=>15, "minute"=>39, "second"=>0},
                           "invoice"=>{"amount"=>7990, "id"=>20874406, "status"=>{"code"=>3, "description"=>"Pago"}},
                           "plan"=>{"code"=>"master-angels", "name"=>"Master", "id"=>"PLA-MC8QAKO4I7GZ"},
                           "next_invoice_date"=>{"month"=>3, "year"=>2020, "day"=>15},
                           "payment_method"=>"CREDIT_CARD",
                           "status"=>"CANCELED",
                           "customer"=>
                             {"code"=>"subscriber-02395039000139",
                              "billing_info"=>
                                {"credit_card"=>
                                  {"first_six_digits"=>"524554",
                                   "expiration_year"=>"21",
                                   "expiration_month"=>"10",
                                   "last_four_digits"=>"4846",
                                   "brand"=>"MASTERCARD",
                                   "vault"=>"CRC-3MHCOY3RND9R",
                                   "holder_name"=>"JOAQUIM DOS SANTOS"}},
                                "fullname"=>"Benjamin Arruda",
                                "id"=>"CUS-Q2SQBJ145IS5",
                                "email"=>"abc@abc.com.br"}} 

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { subscription_data }
      allow(RestClient::Request).to receive(:execute) { response }

      result = described_class.find(subscription_code)

      expect(result).to eq(response)
    end

    it 'returns http status code 500 when occurs some errors' do
      subscription_code = 'subscription-7b7e868f-6a01-4808-a5f3-9c9d6ba3765e'
      subscription_data = {"amount"=>7990,
                           "code"=>subscription_code,
                           "moip_account"=>"MPA-7C15E835293E",
                           "id"=>"SUB-K9DHBUVY9RXX",
                           "creation_date"=>{"month"=>2, "hour"=>16, "year"=>2020, "day"=>15, "minute"=>39, "second"=>0},
                           "invoice"=>{"amount"=>7990, "id"=>20874406, "status"=>{"code"=>3, "description"=>"Pago"}},
                           "plan"=>{"code"=>"master-angels", "name"=>"Master", "id"=>"PLA-MC8QAKO4I7GZ"},
                           "next_invoice_date"=>{"month"=>3, "year"=>2020, "day"=>15},
                           "payment_method"=>"CREDIT_CARD",
                           "status"=>"CANCELED",
                           "customer"=>
                             {"code"=>"subscriber-02395039000139",
                              "billing_info"=>
                                {"credit_card"=>
                                  {"first_six_digits"=>"524554",
                                   "expiration_year"=>"21",
                                   "expiration_month"=>"10",
                                   "last_four_digits"=>"4846",
                                   "brand"=>"MASTERCARD",
                                   "vault"=>"CRC-3MHCOY3RND9R",
                                   "holder_name"=>"JOAQUIM DOS SANTOS"}},
                                "fullname"=>"Benjamin Arruda",
                                "id"=>"CUS-Q2SQBJ145IS5",
                                "email"=>"abc@abc.com.br"}}

      allow(RestClient::Request).to receive(:execute) { raise RestClient::Exception }

      result = described_class.find(subscription_code).code

      expect(result).to eq(500)
    end
  end

  describe '.deactivation' do
    it 'deactivates subscription' do
      subscription_code = 'subscription-1234567890'

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { subscription_data }
      allow(RestClient::Request).to receive(:execute) { response }

      result = described_class.deactivation(subscription_code)

      expect(result).to eq(response)
    end

    it 'returns http status code 500 when occurs some errors' do
      subscription_code = 'subscription-1234567890'

      allow(RestClient::Request).to receive(:execute) { raise RestClient::Exception }

      result = described_class.deactivation(subscription_code).code

      expect(result).to eq(500)
    end
  end

  describe '.reactivation' do
    it 'reactivates subscription' do
      subscription_code = 'subscription-1234567890'

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { subscription_data }
      allow(RestClient::Request).to receive(:execute) { response }

      result = described_class.reactivation(subscription_code)

      expect(result).to eq(response)
    end

    it 'returns http status code 500 when occurs some errors' do
      subscription_code = 'subscription-1234567890'

      allow(RestClient::Request).to receive(:execute) { raise RestClient::Exception }

      result = described_class.reactivation(subscription_code).code

      expect(result).to eq(500)
    end
  end

  describe '.cancellation' do
    it 'cancels subscription' do
      subscription_code = 'subscription-1234567890'

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { subscription_data }
      allow(RestClient::Request).to receive(:execute) { response }

      result = described_class.cancellation(subscription_code)

      expect(result).to eq(response)
    end

    it 'returns http status code 500 when occurs some errors' do
      subscription_code = 'subscription-1234567890'

      allow(RestClient::Request).to receive(:execute) { raise RestClient::Exception }

      result = described_class.cancellation(subscription_code).code

      expect(result).to eq(500)
    end
  end

  describe '.update_recurrence' do
    it 'updates subscription value in payment gateway' do
      subscription_code = 'subscription-1234567890'
      amount_payable = 79.90

      allow(Builders::Payloads::UpdateSubscription).to receive(:data) { {amount: "7990", next_invoice_date: { day: "17", month: "4", year: "2020"}, plan: {code: "master-angels"}} }
      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { "{\"errors\":[]}" }
      allow(described_class).to receive(:call) { response }

      result = described_class.update_recurrence(subscription_code: subscription_code, amount_payable: amount_payable)

      expect(result).to eq(true)
    end

    it 'does not update subscription value in payment gateway when return invalid http status' do
      subscription_code = 'subscription-1234567890'
      amount_payable = 79.90

      allow(Builders::Payloads::UpdateSubscription).to receive(:data) { {amount: "7990", next_invoice_date: { day: "17", month: "4", year: "2020"}, plan: {code: "master-angels"}} }
      response = double()

      allow(response).to receive(:code) { 500 }
      allow(response).to receive(:body) { "{\"errors\":[]}" }
      allow(described_class).to receive(:call) { response }

      result = described_class.update_recurrence(subscription_code: subscription_code, amount_payable: amount_payable)

      expect(result).to eq(false)
    end

    it 'does not update subscription value in payment gateway when return any error' do
      subscription_code = 'subscription-1234567890'
      amount_payable = 79.90

      allow(Builders::Payloads::UpdateSubscription).to receive(:data) { {amount: "7990", next_invoice_date: { day: "17", month: "4", year: "2020"}, plan: {code: "master-angels"}} }
      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { "{\"errors\":[\"any_error\"]}" }
      allow(described_class).to receive(:call) { response }

      result = described_class.update_recurrence(subscription_code: subscription_code, amount_payable: amount_payable)

      expect(result).to eq(false)
    end
  end
end
