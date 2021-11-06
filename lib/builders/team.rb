# frozen_string_literal: true

module Builders
  class Team
    attr_reader :agent_quantity

    def self.mount!
      { team_name: mount_team, agents: mount_agents }
    end

    def self.mount_team
      ::Team
        .available
        .map(&:name)
        .sample
    end

    def self.mount_agents
      Agent
        .available
        .first(::Team::COMPONENTS)
        .map(&:codename)
        .sort
        .join(I18n.t('builders.mission_items.separator'))
    end
  end
end
