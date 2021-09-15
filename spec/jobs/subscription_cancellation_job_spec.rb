require 'rails_helper'

RSpec.describe SubscriptionCancellationJob, type: :job do
  describe '.perform' do
    Status::STATUSES.values.each do |status|
      context "when status is #{status}" do
        it 'updates subscription status to \'cancelado pelo assinante\' when cancel subscription is ordered by subscriber' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          subscription = FactoryBot.create(:subscription, status: status, subscriber: subscriber)

          response = double()

          allow(response).to receive(:code) { 200 }
          allow(response).to receive(:body) { '' }
          allow(Gateways::Payment::Subscription).to receive(:cancellation).with(subscription.code) { response }

          described_class.perform_now(subscriber_code: subscription.code, by_company: false)

          result = Subscription.find_by_code(subscription.code).status

          expect(result).to eq('cancelado pelo assinante')
        end

        it 'updates subscription status to \'cancelado pela empresa\' when cancel subscription is ordered by company' do
          subscriber = FactoryBot.create(:subscriber) 
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          subscription = FactoryBot.create(:subscription, status: status, subscriber: subscriber)

          response = double()

          allow(response).to receive(:code) { 200 }
          allow(response).to receive(:body) { '' }
          allow(Gateways::Payment::Subscription).to receive(:cancellation).with(subscription.code) { response }

          described_class.perform_now(subscriber_code: subscription.code, by_company: true)

          result = Subscription.find_by_code(subscription.code).status

          expect(result).to eq('cancelado pela empresa')
        end

        it 'does not update subscription status when not receive status 200 of payment gateway' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          subscription = FactoryBot.create(:subscription, status: status, subscriber: subscriber)

          response = double()

          allow(response).to receive(:code) { 500 }
          allow(response).to receive(:body) { '' }
          allow(Gateways::Payment::Subscription).to receive(:cancellation).with(subscription.code) { response }

          described_class.perform_now(subscriber_code: subscription.code, by_company: true)

          result = Subscription.find_by_code(subscription.code).status

          expect(result).to eq(status)
        end
      end
    end
  end
end
