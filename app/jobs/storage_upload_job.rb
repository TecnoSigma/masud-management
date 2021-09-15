class StorageUploadJob < ApplicationJob
  queue_as :default

  def perform
    subscriptions_code = Subscription.activated.pluck(:code)
    subscriptions_code.each do |code|
      directory = ::Storage::STORAGE_FOLDER + '/' + code

      next unless Dir.exists?(directory)
      next if Dir.empty?(directory)

      file_list = Dir.entries(directory).sort
      file_list.shift(2)       #remove items: '.' and '..'
      file_list.each do |file|
        if upload_file!(folder_name: code, object: file, object_path: directory)
          full_path = directory + '/' + file

          remove_file!(full_path)

          Rails.logger.info(I18n.t('messages.successes.upload_file', file_name: file))
        else
          Rails.logger.error(I18n.t('messages.errors.upload_file_failed', file_name: file))
        end
      end
    end

    true
  rescue
    Rails.logger.error(I18n.t('messages.errors.upload_files_failed'))

    false
  end

  private

    def upload_file!(folder_name:,  object:, object_path:)
      Gateways::Storage::Object
        .upload(folder_name: folder_name,
                object: object,
                object_path: object_path)
    end

    def remove_file!(full_path)
      File.delete(full_path)
    end
end
