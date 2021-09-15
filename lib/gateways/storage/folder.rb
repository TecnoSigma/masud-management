module Gateways
  module Storage
    module Folder
      class << self
        def create(subscription_code)
          s3 = Aws::S3::Client.new

          raise StorageFolderNotFoundError if has_folder?(subscription_code)

          s3.put_object(bucket: ENV['AWS_DEFAULT_BUCKET'], key: "#{subscription_code}/")

          create_subfolder!(subscription_code)
        rescue StandardError,
               Aws::S3::Errors::NoSuchBucket,
               StorageFolderNotFoundError => e
          Rails.logger.error("Message: #{e.message}")

          false
        end

        def create_subfolder!(subscription_code)
          s3 = Aws::S3::Client.new

          ::Storage.subfolders.values.each do |subfolder|
            next if has_folder?("#{subscription_code}/#{subfolder}/")

            s3.put_object(bucket: ENV['AWS_DEFAULT_BUCKET'], key: "#{subscription_code}/#{subfolder}/")
          end

          true
        end

        def has_folder?(folder_name)
          s3 = Aws::S3::Client.new

          s3
            .list_objects(bucket: ENV['AWS_DEFAULT_BUCKET'])
            .contents
            .pluck(:key)
            .include?("#{folder_name}/")
        end
      end

      private_class_method :has_folder?, :create_subfolder!
    end
  end
end
