require 'rails_helper'

RSpec.describe Builders::Payloads::Payment::CreateSubscription do
  describe '.data' do
    it 'returns subscriber payload' do
      uuid = 'abc-123400'
      allow(SecureRandom).to receive(:uuid) { uuid }

      plan_code = 'plan_abc'
      amount_payable = 100
      subscriber_code = 'subscriber-12345'
      payment_method = 'Cartão de Crédito'

      result = described_class.data(plan_code: plan_code, amount_payable: amount_payable, subscriber_code: subscriber_code, payment_method: payment_method)
      
      expected_result = { code: "subscription-#{uuid}",
                          amount: 10000,
                          customer: { code: 'subscriber-12345' },
                          payment_method: 'CREDIT_CARD',
                          plan: {code: 'plan_abc' } }

      expect(result).to eq(expected_result)
    end
  end
end
