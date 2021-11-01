# frozen_string_literal: true

class Agent < Employee
  validates :cvn_number,
            format: { with: Regex.cvn_number,
                      message: I18n.t('messages.errors.invalid_format') }

  has_many :tackles
  belongs_to :team, optional: true

  before_create :clear_password

  INTERVAL_BETWEEN_MISSIONS = 13 # in hours

  scope :actives, -> { where(status: Status.find_by_name('ativo')) }

  def self.available
    beginner_agents + sorted_rested_agents
  end

  def rested?
    TimeDifference.between(last_mission, Time.zone.now).in_hours > INTERVAL_BETWEEN_MISSIONS
  end

  def expired_cvn?
    cvn_validation_date < Date.today
  end

  def clear_password
    self.password = nil
  end

  def self.rested_agents
    actives.select do |agent|
      agent.in_mission == false && agent.last_mission.present? && agent.rested?
    end
  end

  def self.beginner_agents
    actives.select { |agent| agent.in_mission == false && agent.last_mission.nil? }
  end

  def self.sorted_rested_agents
    rested = rested_agents

    rested.any? ? rested.sort { |first, last| last.last_mission <=> first.last_mission } : rested
  end

  private_class_method :rested_agents, :beginner_agents, :sorted_rested_agents
end
