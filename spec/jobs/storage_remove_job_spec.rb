require 'rails_helper'

RSpec.describe StorageRemoveJob, type: :job do
  describe '.perform' do
    it 'calls to remove file' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Subscription).to receive_message_chain(:activated, :pluck) { [subscription.code] }

      file = double()
      allow(file).to receive(:last_modified) { 3.months.ago }
      allow(file).to receive(:key) { "#{subscription.code}/images/object.png" }
      allow(Gateways::Storage::Object).to receive(:all_objects) { file }
      allow(Gateways::Storage::Object).to receive(:remove) { true } 

      expect(described_class.perform_now).to eq(true)
    end

    it 'does not call to remove file when occur some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Subscription).to receive_message_chain(:activated, :pluck) { [subscription.code] }

      file = double()
      allow(file).to receive(:last_modified) { 3.months.ago }
      allow(file).to receive(:key) { "#{subscription.code}/images/object.png" }
      allow(Gateways::Storage::Object).to receive(:all_objects) { raise StandardError }

      expect(described_class.perform_now).to eq(false)
    end
  end
end
