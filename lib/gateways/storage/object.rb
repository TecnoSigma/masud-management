module Gateways
  module Storage
    module Object
      class << self
        def upload(folder_name:, object:, object_path:)
          return false unless has_folder?(folder_name)  

          subfolder = ::Storage.subfolder(object_path, object)
          raise AllowedMimeTypeError if subfolder.blank?

          obj = Aws::S3::Resource
                  .new
                  .bucket(ENV['AWS_DEFAULT_BUCKET'])
                  .object("#{folder_name}/#{subfolder}/#{object}")
          obj.upload_file("#{object_path}/#{object}")
        rescue AllowedMimeTypeError => e
          Rails.logger.error("Message: #{e.message}")

          false
        end

        def remove(folder_name:, object:)
          return false unless has_folder?(folder_name)
          return false unless has_object?(object)

          Aws::S3::Client.new.delete_object({bucket: ENV['AWS_DEFAULT_BUCKET'], key: object})
        end

        def remove_all(folder_name)
          return false unless has_folder?(folder_name)

          all_objects(folder_name: folder_name, all_info: false).each { |object| remove(folder_name: folder_name, object: object) }

          true
        end

        def all_objects(folder_name:, all_info: true)
          object_list = Array.new

          ::Storage::SUBFOLDER_LIST.each do |subfolder|
            object = Aws::S3::Client
                       .new
                       .list_objects(bucket: ENV['AWS_DEFAULT_BUCKET'], prefix: "#{folder_name}/#{subfolder}")
                       .contents
                       .map { |item| item unless item.key == "#{folder_name}/#{subfolder}/" }
                       .compact

            object_list << object
          end

          all_info ? object_list : object_list.flatten.pluck(:key)
        end

        def has_folder?(folder_name)
          Aws::S3::Client.new.get_object({bucket: ENV['AWS_DEFAULT_BUCKET'], key: "#{folder_name}/"})

          true
        rescue Aws::S3::Errors::NoSuchKey => e
          Rails.logger.error("Message: #{e.message} - Backytrace: #{e.backtrace})")

          false
        end

        def has_object?(object)
          Aws::S3::Client.new.get_object({bucket: ENV['AWS_DEFAULT_BUCKET'], key: object})

          true
        rescue Aws::S3::Errors::NoSuchKey => e
          Rails.logger.error("Message: #{e.message} - Backytrace: #{e.backtrace})")

          false
        end
      end

      private_class_method :has_folder?, :has_object?
    end
  end
end
