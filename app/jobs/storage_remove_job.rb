class StorageRemoveJob < ApplicationJob
  queue_as :default

  def perform
    all_files.each do |file|
      begin
        remove_file(file) if ::Storage.deletable_file?(file.last_modified)
      rescue
        file_name = file.key.split('/').last
        Rails.logger.error(I18n.t('messages.errors.remove_file_failed', file_name: file_name))

        next
      end
    end

    true
  rescue => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    false
  end

  private

    def remove_file(file)
      folder_name = file.key.split('/').first

      Gateways::Storage::Object.remove(folder_name: folder_name, object: file.key)
    end

    def all_files
      file_list = Array.new

      Subscription.activated.pluck(:code).each do |code|
        file_list << Gateways::Storage::Object.all_objects(folder_name: code)
      end

      file_list.uniq.flatten
    end
end
