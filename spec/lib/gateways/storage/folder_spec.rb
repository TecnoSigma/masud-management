require 'rails_helper'

RSpec.describe Gateways::Storage::Folder do
  describe '.create' do
    it 'creates folder when exist bucket' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { false }
      allow(Aws::S3::Client).to receive_message_chain(:new, :put_object) { response }

      result = described_class.create(subscription.code)

      expect(result).to eq(true)
    end

    it 'creates subfolder to stock videos files inside main folder' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])
    
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { false }
      allow(Aws::S3::Client).to receive_message_chain(:new, :put_object) { response }

      result = described_class.create(subscription.code)

      expect(result).to eq(true)

    end

    it 'creates subfolder to stock images files inside main folder' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])
    
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { false }
      allow(Aws::S3::Client).to receive_message_chain(:new, :put_object) { response }

      result = described_class.create(subscription.code)

      expect(result).to eq(true)
    end

    it 'does not create folder when no exist bucket' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { false }
      allow(Aws::S3::Client).to receive_message_chain(:new, :put_object) { raise Aws::S3::Errors::NoSuchBucket }

      result = described_class.create(subscription.code)

      expect(result).not_to eq(response)
    end

    it 'does not create folder when exist a folder with same name' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { true }

      result = described_class.create(subscription.code)

      expect(result).not_to eq(response)
    end

    it 'does not create folder when ocurrs some errors' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      etag = SecureRandom.uuid

      response = double()

      allow(response).to receive(:etag) { etag }
      allow(described_class).to receive(:has_folder?) { raise StandardError }

      result = described_class.create(subscription.code)

      expect(result).not_to eq(response)
    end
  end
end
