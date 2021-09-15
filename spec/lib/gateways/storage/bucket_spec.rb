require 'rails_helper'

RSpec.describe Gateways::Storage::Bucket do
  describe '.create' do
    it 'creates new bucket in AWS storage' do
      location="http://protector-angels.s3.amazonaws.com/"

      response = double()

      allow(response).to receive(:location) { location }
      allow(Aws::S3::Client).to receive_message_chain(:new, :create_bucket) { response }

      result = described_class.create

      expect(result).to eq(response)
    end

    it 'does not create new bucket when exist default bucket' do
      location="http://protector-angels.s3.amazonaws.com/"

      response = double()

      allow(response).to receive(:location) { location }
      allow(Aws::S3::Client).to receive_message_chain(:new, :create_bucket) { raise Aws::S3::Errors::BucketAlreadyOwnedByYou }

      result = described_class.create

      expect(result).not_to eq(response)
    end

    it 'does not create new bucket when exist occurs some errors' do
      location="http://protector-angels.s3.amazonaws.com/"

      response = double()

      allow(response).to receive(:location) { location }
      allow(Aws::S3::Client).to receive_message_chain(:new, :create_bucket) { raise StandardError }

      result = described_class.create

      expect(result).not_to eq(response)
    end
  end
end
