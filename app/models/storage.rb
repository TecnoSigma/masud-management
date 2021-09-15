class Storage
  IMAGE_MIME_TYPES = ['image/gif', 'image/jpeg', 'image/png'].freeze
  VIDEO_MIME_TYPES = ['video/mp4'].freeze
  SUBFOLDER_LIST = %w(images videos).freeze
  PERMISSION_TO_FOLDER = 0777.freeze
  STORAGE_FOLDER = 'app/storage'.freeze
  FILE_LIFE_TIME = 3.freeze # months

  def self.deletable_file?(date)
    date <= FILE_LIFE_TIME.months.ago
  end

  def self.subfolders
    Hash[Storage::SUBFOLDER_LIST.collect { |item| [item, item] }].symbolize_keys
  end

  def self.subfolder(object_path, object)
    mime_type = mime_type(object_path, object)

    case
      when IMAGE_MIME_TYPES.include?(mime_type)
        subfolders[:images]
      when VIDEO_MIME_TYPES.include?(mime_type)
        subfolders[:videos]
      else
        '' 
    end
  end

  def self.mime_type(object_path, object)
    `file --b --mime-type "#{object_path}/#{object}"`.strip
  end

  def self.create_folder(subscription_code)
    dir = "app/storage/#{subscription_code}/"

    raise CreateNewDirectoryError if Dir.exists?(dir)

    Dir.mkdir(dir)

    File.chmod(PERMISSION_TO_FOLDER, dir)

    true
  rescue CreateNewDirectoryError => e
    Rails.logger.error("Message: #{e.message}")

    false
  end
end
