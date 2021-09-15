require 'rails_helper'

RSpec.describe Gateways::Storage::Object do
  describe '.upload' do
    context 'when object is a image' do
      it 'uploads objects to storage gateway' do
        file_name = 'object.gif'
        file_path = 'spec/fixtures'

        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        subscription = FactoryBot.create(:subscription, subscriber: subscriber)
        subscription.update_attributes!(status: Status::STATUSES[:activated])

        allow(Aws::S3::Client).to receive_message_chain(:new, :get_object) { true } 
        allow(Aws::S3::Resource).to receive_message_chain(:new, :bucket, :object, :upload_file) { true }

        result = described_class.upload(folder_name: subscription.code, object: file_name, object_path: file_path)

        expect(result).to eq(true)
      end
    end

    context 'when object is a video' do
      it 'uploads objects to storage gateway' do
        file_name = 'object.gif'
        file_path = 'spec/fixtures'

        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        subscription = FactoryBot.create(:subscription, subscriber: subscriber)
        subscription.update_attributes!(status: Status::STATUSES[:activated])

        allow(Aws::S3::Client).to receive_message_chain(:new, :get_object) { true }
        allow(Aws::S3::Resource).to receive_message_chain(:new, :bucket, :object, :upload_file) { true }

        result = described_class.upload(folder_name: subscription.code, object: file_name, object_path: file_path)

        expect(result).to eq(true)
      end
    end

    it 'does not upload object when bucket folder not exist' do
        file_name = 'object.gif'
        file_path = 'spec/fixtures'

        result = described_class.upload(folder_name: 'anything', object: file_name, object_path: file_path)

        expect(result).to eq(false)
    end

    it 'does not upload video files when video folder not exist' do
      file_name = 'object.mp4'
      file_path = 'spec/fixtures'

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Storage).to receive(:subfolder) { 'anyfolder' }

      result = described_class.upload(folder_name: subscription.code, object: file_name, object_path: file_path)

      expect(result).to eq(false)
    end

    it 'does not upload image files when image folder not exist' do
      file_name = 'object.gif'
      file_path = 'spec/fixtures'

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(Storage).to receive(:subfolder) { 'anyfolder' }

      result = described_class.upload(folder_name: subscription.code, object: file_name, object_path: file_path)

      expect(result).to eq(false)
    end

    it 'uploads only files with allowed types' do
      file_name = 'object.txt'
      file_path = 'spec/fixtures'

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      result = described_class.upload(folder_name: subscription.code, object: file_name, object_path: file_path)

      expect(result).to eq(false)
    end
  end

  describe '.remove' do
    it 'removes chosen object' do
      file_path = 'spec/fixtures'
      file_name = 'object.gif'

      allow(Aws::S3::Client).to receive_message_chain(:new, :get_object) { true }
      allow(Aws::S3::Client).to receive_message_chain(:new, :delete_object) { true }

      result = described_class.remove(folder_name: file_path, object: file_name)

      expect(result).to eq(true)
    end

    it 'does not remove chosen object when folder not exist' do
      file_path = 'spec/fixtures'
      file_name = 'object.gif'

      allow(described_class).to receive(:has_folder?) { false }

      result = described_class.remove(folder_name: file_path, object: file_name)

      expect(result).to eq(false)
    end

    it 'does not remove chosen object when object not exist' do
      file_path = 'spec/fixtures'
      file_name = 'object.gif'

      allow(described_class).to receive(:has_object?) { false }

      result = described_class.remove(folder_name: file_path, object: file_name)

      expect(result).to eq(false)
    end
  end

  describe '.remove_all' do
    it 'removes all object' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(described_class).to receive(:has_folder?) { true }
      allow(described_class).to receive(:all_objects) { ["#{subscription.code}/images/object.gif"] }
      allow(described_class).to receive(:remove) { true }

      result = described_class.remove_all(subscription.code)

      expect(result).to eq(true)
    end

    it 'does not remove any object when folder not exist' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      subscription.update_attributes!(status: Status::STATUSES[:activated])

      allow(described_class).to receive(:has_folder?) { false }

      result = described_class.remove_all(subscription.code)

      expect(result).to eq(false)
    end
  end
end
