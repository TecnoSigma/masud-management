# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bullet, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Bullet and Employee' do
      bullet = Bullet.new

      expect(bullet).to respond_to(:employee)
    end
  end

  describe 'validates presences' do
    it 'of caliber' do
      bullet = FactoryBot.build(:bullet, caliber: nil)

      expect(bullet).to be_invalid
    end
  end
end
