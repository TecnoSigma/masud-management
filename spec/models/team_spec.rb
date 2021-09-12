require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (1:N) between Team and Employee' do
      team = Team.new

      expect(team).to respond_to(:employees)
    end
  end

  it 'validates presence of name' do
    team = FactoryBot.build(:team, name: nil)

    expect(team).to be_invalid
  end
end
