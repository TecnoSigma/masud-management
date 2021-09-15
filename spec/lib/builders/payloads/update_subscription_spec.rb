require 'rails_helper'

RSpec.describe Builders::Payloads::UpdateSubscription do
  describe '.data' do
    it 'returns payload containing data to update subscription' do
      amount_payable = 79.90
      subscription_code = 'subscription-75ce96e6-7123-4a59-93f0-eb3d10288cc7'
      subscription_data = "{\"amount\":#{(amount_payable * 100.0).to_i.to_s},\"code\":\"#{subscription_code}\",\"moip_account\":\"MPA-7C15E835293E\",\"id\":\"SUB-KSOZINYHBNE3\",\"creation_date\":{\"month\":3,\"hour\":6,\"year\":2020,\"day\":17,\"minute\":30,\"second\":29},\"invoice\":{\"amount\":9275,\"id\":20875714,\"status\":{\"code\":3,\"description\":\"Pago\"}},\"plan\":{\"code\":\"master-angels\",\"name\":\"Master\",\"id\":\"PLA-MC8QAKO4I7GZ\"},\"next_invoice_date\":{\"month\":4,\"year\":2020,\"day\":17},\"payment_method\":\"CREDIT_CARD\",\"status\":\"ACTIVE\",\"customer\":{\"code\":\"subscriber-00867737000106\",\"billing_info\":{\"credit_card\":{\"first_six_digits\":\"518271\",\"expiration_year\":\"21\",\"expiration_month\":\"05\",\"last_four_digits\":\"8250\",\"brand\":\"MASTERCARD\",\"vault\":\"CRC-BZUDQA2QQTNZ\",\"holder_name\":\"CASSIO GOLEIRO\"}},\"fullname\":\"Cassio dos Santos\",\"id\":\"CUS-04P33802VI6L\",\"email\":\"tecnosigma@tecnosigma.com.br\"}}"

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { subscription_data }
      allow(Gateways::Payment::Subscription).to receive(:call) { response }

      result = described_class.data(subscription_code: subscription_code, amount_payable: amount_payable)

      expect(result).to eq({amount: "7990", next_invoice_date: { day: "17", month: "4", year: "2020"}, plan: {code: "master-angels"}})
    end
  end
end
