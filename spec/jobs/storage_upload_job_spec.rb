require 'rails_helper'

RSpec.describe StorageUploadJob, type: :job do
  describe '.perform' do
    it 'calls job to upload file' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Dir).to receive(:exists?) { true }
      allow(Dir).to receive(:empty?) { false }
      allow(Dir).to receive_message_chain(:entries, :sort) { ['object.gif'] }
      allow(Gateways::Storage::Object).to receive(:upload) { true }
      allow(File).to receive(:delete) { true }

      expect(described_class.perform_now).to eq(true)
    end

    it 'does not call job to upload file when occurs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Dir).to receive(:exists?) { raise StandardError }
      allow(Dir).to receive(:empty?) { false }
      allow(Dir).to receive_message_chain(:entries, :sort) { ['object.gif'] }
      allow(Gateways::Storage::Object).to receive(:upload) { true }
      allow(File).to receive(:delete) { true }

      expect(described_class.perform_now).to eq(false)
    end
  end
end
