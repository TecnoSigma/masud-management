class Ticket < ApplicationRecord
  ALLOWED_DEPARTMENTS = ['Técnico', 'Financeiro', 'Cadastral'].freeze
  GROUPS = { opened: 'opened',
             in_treatment: 'in_treatment',
             recurrence: 'recurrence',
             finished: 'finished' }.freeze

  has_many :comments, dependent: :destroy
  belongs_to :subscriber

  validates :department,
            :subject,
            :status,
            presence: { message: Messages.errors[:required_field] }

  validates :responsible,
            presence: { message: Messages.errors[:required_field] },
            unless: :opened?

  validate :check_initial_status
  validate :check_allowed_delayed
  validate :check_allowed_finished

  scope :recurrence,
    -> (subscriber) { subscriber
                        .tickets
                        .select { |ticket| ticket.status == Status::TICKET_STATUSES[:recurrence] }
                        .sort { |a, b| b.created_at <=> a.created_at } }

  scope :opened,
    -> (subscriber) { subscriber
                        .tickets
                        .select { |ticket| ticket.status == Status::TICKET_STATUSES[:opened] }
                        .sort{ |a, b| b.created_at <=> a.created_at } }
  scope :finished,
    -> (subscriber) { subscriber
                        .tickets
                        .select { |ticket| ticket.status == Status::TICKET_STATUSES[:finished] }
                        .sort{ |a, b| b.created_at <=> a.created_at } }
  scope :in_treatment,
    -> (subscriber) { subscriber
                        .tickets
                        .select { |ticket| ticket.status == Status::TICKET_STATUSES[:in_treatment] ||
                                           ticket.status == Status::TICKET_STATUSES[:waiting_subscriber] ||
                                           ticket.status == Status::TICKET_STATUSES[:waiting_company] }
                        .sort{ |a, b| b.created_at <=> a.created_at } }
  scope :available,
    -> (subscriber) { subscriber
                        .tickets
                        .select { |ticket| ticket.status == Status::TICKET_STATUSES[:in_treatment] ||
                                           ticket.status == Status::TICKET_STATUSES[:waiting_subscriber] ||
                                           ticket.status == Status::TICKET_STATUSES[:waiting_company] ||
                                           ticket.status == Status::TICKET_STATUSES[:finished] ||
                                           ticket.status == Status::TICKET_STATUSES[:opened] }
                        .sort{ |a, b| b.created_at <=> a.created_at } }

  def opened?
    self.status == Status::TICKET_STATUSES[:opened]
  end

  def finished?
    self.status == Status::TICKET_STATUSES[:finished]
  end

  def check_initial_status
    unless self.persisted?
      message = Messages.errors[:invalid_status]

      errors.add(:status, message) unless self.status == Status::TICKET_STATUSES[:opened]
    end
  end

  def check_allowed_delayed
    unless self.persisted?
      errors.add(:delayed, Messages.errors[:invalid_status]) if self.delayed
    end
  end

  def check_allowed_finished
    unless self.persisted?
      errors.add(:finished, Messages.errors[:invalid_status]) if self.finished
    end
  end
end
