require 'rails_helper'

RSpec.describe Storage do
  describe '.subfolders' do
    it 'returns hash containing subfolder names' do
      result = described_class.subfolders

      expect(result).to eq({ images: 'images', videos: 'videos' })
    end
  end

  describe '.subfolder' do
    it 'returns allowed subfolders list to stock images and videos' do
      expected_result = ['images', 'videos']

      expect(Storage::SUBFOLDER_LIST).to eq(expected_result)
    end

    it 'returns hash containing default subfolders to stock images and videos' do
      expected_result = { images: 'images', videos: 'videos' }
      
      expect(described_class.subfolders).to eq(expected_result)
    end
  end

  describe '.mime_type' do
    it 'returns file mime-type' do
      file_name = 'object.mp4'
      file_path = 'spec/fixtures'

      result = described_class.mime_type(file_path, file_name)

      expect(result).to eq('video/mp4')
    end
  end

  describe '.create_folder' do
    it 'creates storage directory when no exist directory' do
      subscription_code = 'subscription-12345'

      allow(Dir).to receive(:exists?) { false }
      allow(Dir).to receive(:mkdir) { 0 }
      allow(File).to receive(:chmod) { 1 }

      result = described_class.create_folder(subscription_code)

      expect(result).to eq(true)
    end

    it 'does not create storage directory when exist directory' do
      subscription_code = 'subscription-12345'

      allow(Dir).to receive(:exists?) { true }

      result = described_class.create_folder(subscription_code)

      expect(result).to eq(false)
    end
  end

  describe '.deletable_file?' do
    it 'returns \'true\' when date is greater than three months' do
      date = 4.months.ago

      result = described_class.deletable_file?(date)

      expect(result).to eq(true)
    end

    it 'returns \'true\' when date is equal three months' do
      date = 3.months.ago

      result = described_class.deletable_file?(date)

      expect(result).to eq(true)
    end

    it 'returns \'false\' when date is less than three months' do
      date = 2.months.ago

      result = described_class.deletable_file?(date)

      expect(result).to eq(false)
    end
  end

  it 'returns file life time (in months)' do
    result = described_class::FILE_LIFE_TIME

    expect(result).to eq(3)
  end

  it 'returns permission to write and read to storage directory' do
    permission_code = 0777

    result = Storage::PERMISSION_TO_FOLDER

    expect(result).to eq(permission_code)
  end
end
