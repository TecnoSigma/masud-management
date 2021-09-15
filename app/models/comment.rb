class Comment < ApplicationRecord
  has_one_attached :image
  belongs_to :ticket

  validates :content,
            :author,
            presence: { message: Messages.errors[:required_field] }

  ALLOWED_ATTACHMENT_TYPE_LIST = ['image/gif', 'image/jpg', 'image/jpeg', 'image/gif'].freeze

  def allowed_attachment_type?(file_content_type)
    ALLOWED_ATTACHMENT_TYPE_LIST.include?(file_content_type)
  end

  def allowed_attachment_size?(file_size)
    file_size.between?(1.byte, 5.megabytes)
  end
end
