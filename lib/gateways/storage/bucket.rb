# frozen_string_literal: true

module Gateways
  module Storage
    module Bucket
      class << self
        def create
          s3 = Aws::S3::Client.new

          s3.create_bucket(bucket: ENV['AWS_DEFAULT_BUCKET'])
        rescue StandardError, Aws::S3::Errors::BucketAlreadyOwnedByYou => e
          Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")
        end
      end
    end
  end
end
