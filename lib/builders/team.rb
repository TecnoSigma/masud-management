# frozen_string_literal: true

module Builders
  class Team
    attr_reader :agent_quantity

    def initialize(agent_quantity)
      @agent_quantity = agent_quantity.to_i
    end

    def mount!
      { team_name: mount_team, agents: mount_agents }
    end

    private

    def mount_team
      ::Team
        .available
        .map(&:name)
        .sample
    end

    def mount_agents
      Agent
        .available
        .first(agent_quantity)
        .map(&:codename)
        .sort
        .join(I18n.t('builders.mission_items.separator'))
    end
  end
end
