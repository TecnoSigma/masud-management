require 'rails_helper'

RSpec.describe Profile, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:N) between Employee and Profile' do
      profile = Profile.new

      expect(profile).to respond_to(:employees)
    end
  end

  describe 'validates presence' do
    it 'no validates when no pass name' do
      profile = FactoryBot.build(:profile, :administrator, name: nil)

      expect(profile).to be_invalid
    end

    it 'no validates when no pass kind' do
      profile = FactoryBot.build(:profile, :administrator, kind: nil)

      expect(profile).to be_invalid
    end
  end
end
