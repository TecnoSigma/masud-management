class Angel < ApplicationRecord
  validates :name,
            :cpf,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :cpf,
            format: { with: Regex.cpf,
                      message: Messages.errors[:invalid_format] }

  validate :allowed_status?

  belongs_to :subscriber
  has_and_belongs_to_many :drivers

  ALLOWED_STATUSES = [Status::STATUSES[:activated],
                      Status::STATUSES[:deactivated],
                      Status::STATUSES[:deleted]]

  scope :sort_by_name, -> { sort_by { |angel| angel.name } }
  scope :active, -> { where(status: Status::STATUSES[:activated]) }

  def self.activated_protected(document)
    where(cpf: document)
      .map { |angel| [angel.subscriber.code, angel.subscriber.name] if angel.subscriber.active? }
      .uniq
      .sort_by { |name| name.last }
  end

  def allowed_status?
    if ALLOWED_STATUSES.exclude?(self.status)
      errors.add(:status, Messages.errors[:invalid_status])
    end
  end

  def activated?
    self.status == Status::STATUSES[:activated]
  end
end
