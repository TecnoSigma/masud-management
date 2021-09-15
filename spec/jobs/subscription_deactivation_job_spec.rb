require 'rails_helper'

RSpec.describe SubscriptionDeactivationJob, type: :job do
  describe '.perform' do
    it 'does not update subscriber status to \'desativado\'' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      subscription = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber)

      body = "{\"amount\":9990,\"code\":\"subscription-6542f26f-0ea6-4694-aaa2-a40d59fb7b13\",\"moip_account\":\"MPA-7C15E835293E\",\"id\":\"SUB-M6R14CRSFSR4\",\"creation_date\":{\"month\":2,\"hour\":23,\"year\":2020,\"day\":15,\"minute\":52,\"second\":15},\"invoice\":{\"amount\":9990,\"id\":20874411,\"status\":{\"code\":3,\"description\":\"Pago\"}},\"plan\":{\"code\":\"premium-angels\",\"name\":\"Premium\",\"id\":\"PLA-IBB6L4G53KCN\"},\"next_invoice_date\":{\"month\":3,\"year\":2020,\"day\":14},\"payment_method\":\"CREDIT_CARD\",\"status\":\"SUSPENDED\",\"customer\":{\"code\":\"subscriber-00867737000106\",\"billing_info\":{\"credit_card\":{\"first_six_digits\":\"518271\",\"expiration_year\":\"21\",\"expiration_month\":\"05\",\"last_four_digits\":\"8250\",\"brand\":\"MASTERCARD\",\"vault\":\"CRC-BZUDQA2QQTNZ\",\"holder_name\":\"CASSIO GOLEIRO\"}},\"fullname\":\"Cassio dos Santos\",\"id\":\"CUS-04P33802VI6L\",\"email\":\"anything@anything.com.br\"}}"

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(Gateways::Payment::Subscription).to receive(:find).with(subscription.code) { response }

      described_class.perform_now

      result = Subscriber.find(subscriber.id).status

      expect(Subscriber.find(subscriber.id).status).not_to eq('desativado')
    end

    it 'updates subscription status to \'desativado\'' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      subscription = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber)

      body = "{\"amount\":9990,\"code\":\"subscription-6542f26f-0ea6-4694-aaa2-a40d59fb7b13\",\"moip_account\":\"MPA-7C15E835293E\",\"id\":\"SUB-M6R14CRSFSR4\",\"creation_date\":{\"month\":2,\"hour\":23,\"year\":2020,\"day\":15,\"minute\":52,\"second\":15},\"invoice\":{\"amount\":9990,\"id\":20874411,\"status\":{\"code\":3,\"description\":\"Pago\"}},\"plan\":{\"code\":\"premium-angels\",\"name\":\"Premium\",\"id\":\"PLA-IBB6L4G53KCN\"},\"next_invoice_date\":{\"month\":3,\"year\":2020,\"day\":14},\"payment_method\":\"CREDIT_CARD\",\"status\":\"SUSPENDED\",\"customer\":{\"code\":\"subscriber-00867737000106\",\"billing_info\":{\"credit_card\":{\"first_six_digits\":\"518271\",\"expiration_year\":\"21\",\"expiration_month\":\"05\",\"last_four_digits\":\"8250\",\"brand\":\"MASTERCARD\",\"vault\":\"CRC-BZUDQA2QQTNZ\",\"holder_name\":\"CASSIO GOLEIRO\"}},\"fullname\":\"Cassio dos Santos\",\"id\":\"CUS-04P33802VI6L\",\"email\":\"anything@anything.com.br\"}}"

      response = double()

      allow(response).to receive(:code) { 200 }
      allow(response).to receive(:body) { body }
      allow(Gateways::Payment::Subscription).to receive(:find).with(subscription.code) { response }

      described_class.perform_now

      result = Subscriber.find(subscriber.id).status

      expect(Subscription.find(subscription.id).status).to eq('desativado')
    end

    it 'does not update subscriber status to \'desativado\' when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      subscription = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber)

      allow(Gateways::Payment::Subscription).to receive(:find).with(subscription.code) { raise StandardError }

      described_class.perform_now

      result = Subscriber.find(subscriber.id).status

      expect(Subscriber.find(subscriber.id).status).to eq('ativado')
    end

    it 'does not update subscription status to \'desativado\' when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      subscription = FactoryBot.create(:subscription, status: 'ativado', subscriber: subscriber)

      allow(Gateways::Payment::Subscription).to receive(:find).with(subscription.code) { raise StandardError }

      described_class.perform_now

      result = Subscriber.find(subscriber.id).status

      expect(Subscription.find(subscription.id).status).to eq('ativado')
    end
  end
end
