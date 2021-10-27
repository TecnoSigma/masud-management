# frozen_string_literal: true

class Agent < Employee
  validates :cvn_number,
            format: { with: Regex.cvn_number,
                      message: I18n.t('messages.errors.invalid_format') }

  has_many :arsenals
  has_many :tackles
  belongs_to :team, optional: true

  before_create :clear_password

  INTERVAL_BETWEEN_MISSIONS = 13 # in hours

  def self.available
    agents = Agent.all.inject([]) { |list, agent| list << agent if agent.active? && agent.rested? }

    agents || []
  end

  def active?
    status == Status.find_by_name('ativo')
  end

  def rested?
    return true if team.nil?
    return false if team.mission && team.mission.finished_at.nil?

    TimeDifference
      .between(finished_date, Time.zone.now).in_hours > INTERVAL_BETWEEN_MISSIONS
  end

  def expired_cvn?
    cvn_validation_date < Date.today
  end

  def clear_password
    self.password = nil
  end

  private

  def finished_date
    MissionHistory
      .select { |mission_history| mission_history if mission_history.agents.include?(cvn_number) }
      .last
      .mission
      .finished_at
  end
end
