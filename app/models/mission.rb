# frozen_string_literal: true

class Mission < ApplicationRecord
  has_one :mission_history
  belongs_to :team
  belongs_to :escort_service
  belongs_to :status

  def started?
    started_at.present?
  end
end
