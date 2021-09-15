require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'no validates when not pass content' do
    comment = FactoryBot.build(:comment, content: nil)

    expect(comment).to be_invalid
    expect(comment.errors[:content]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when not pass author' do
    comment = FactoryBot.build(:comment, author: nil)

    expect(comment).to be_invalid
    expect(comment.errors[:author]).to include('Preenchimento de campo obrigatório!')
  end

  describe 'validates relationships' do
    it 'validates relationship N:1 between Comment and Ticket' do
      comment = Comment.new

      expect(comment).to respond_to(:ticket)
    end

    it 'validates relationship 1:1 between Comment and Image (attachment)' do
      comment = Comment.new

      expect(comment).to respond_to(:image)
    end
  end

  describe '#allowed_attachment_type?' do
    context 'returns \'true\'' do
      it 'when file content type is \'image/gif\'' do
        content_type = 'image/gif'

        result = described_class.new.allowed_attachment_type?(content_type)

        expect(result).to eq(true)
      end

      it 'when file content type is \'image/jpg\'' do
        content_type = 'image/jpg'

        result = described_class.new.allowed_attachment_type?(content_type)

        expect(result).to eq(true)
      end

      it 'when file content type is \'image/jpeg\'' do
        content_type = 'image/jpeg'

        result = described_class.new.allowed_attachment_type?(content_type)

        expect(result).to eq(true)
      end
    end

    context 'returns \'false\'' do
      it 'when content type file is other' do
        content_type = 'text/plain'
        
        result = described_class.new.allowed_attachment_type?(content_type)

        expect(result).to eq(false)
      end
    end
  end

  describe '#allowed_attachment_size?' do
    context 'returns \'true\'' do
      it 'when size file is equal than 1 byte' do
        size_file = 1.byte

        result = described_class.new.allowed_attachment_size?(size_file)

        expect(result).to eq(true)
      end

      it 'when size file is equal than 5 megabytes' do
        size_file = 5.megabytes

        result = described_class.new.allowed_attachment_size?(size_file)

        expect(result).to eq(true)
      end

      it 'when size file is between 1 byte and 5 megabytes' do
        size_file = 2.megabytes

        result = described_class.new.allowed_attachment_size?(size_file)

        expect(result).to eq(true)
      end
    end

    context 'returns \'false\'' do
      it 'when size file is greater than 5 megabytes' do
        size_file = 10.megabytes

        result = described_class.new.allowed_attachment_size?(size_file)

        expect(result).to eq(false)
      end
    end
  end
end
