# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Builders::Team' do
  describe '#mount!' do
    it 'mounts team' do
      agents = %w[Alves Silva]
      team_name = 'Tango'

      allow(Team).to receive_message_chain(:available, :map, :sample) { team_name }
      allow(Agent).to receive_message_chain(:available, :first, :map) { agents }

      expected_result = { agents: "#{agents.first} | #{agents.last}", team_name: team_name }

      result = Builders::Team.mount!

      expect(result).to eq(expected_result)
    end
  end
end
