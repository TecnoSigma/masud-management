# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gun, type: :model do
  describe 'validates relationships' do
    it 'validates relationship (N:1) between Status and Gun' do
      gun = Gun.new

      expect(gun).to respond_to(:status)
    end

    it 'validates relationship (N:1) between Employee and Gun' do
      gun = Gun.new

      expect(gun).to respond_to(:employee)
    end
  end

  describe 'validates presences' do
    it 'of number' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, number: nil))

      expect(gun).to be_invalid
    end

    it 'of kind' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, kind: nil))

      expect(gun).to be_invalid
    end

    it 'of caliber' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, caliber: nil))

      expect(gun).to be_invalid
    end

    it 'of sinarm' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, sinarm: nil))

      expect(gun).to be_invalid
    end

    it 'of situation' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, situation: nil))

      expect(gun).to be_invalid
    end

    it 'of registration_validity' do
      gun = Gun.new(FactoryBot.attributes_for(:arsenal, :gun, registration_validity: nil))

      expect(gun).to be_invalid
    end
  end

  it 'validates when the default value of linked_at_post is \'false\'' do
    gun = Gun.new

    result = gun.linked_at_post

    expect(result).to eq(false)
  end

  it 'returns allowed types list' do
    result = described_class::ALLOWED_TYPES

    expected_result = { revolver: 'Revólver', shotgun: 'Espingarda' }

    expect(result).to eq(expected_result)
  end

  describe 'validates scopes' do
    context 'when is a gun' do
      context 'caliber is 38' do
        it 'returns only free guns with caliber 38' do
          agent = FactoryBot.create(:employee, :agent)
          FactoryBot.create(:arsenal, :gun, employee: agent)
          FactoryBot.create(:arsenal, :gun, employee: nil, caliber: '12')
          FactoryBot.create(:arsenal, :gun, employee: nil, caliber: '38')

          expected_result = Gun.where(caliber: '38').where(employee: nil)

          result = Gun.free('38')

          expect(result).to eq(expected_result)
        end
      end

      context 'caliber is 12' do
        it 'returns only free guns with caliber 12' do
          agent = FactoryBot.create(:employee, :agent)
          FactoryBot.create(:arsenal, :gun, employee: agent)
          FactoryBot.create(:arsenal, :gun, employee: nil, caliber: '12')
          FactoryBot.create(:arsenal, :gun, employee: nil, caliber: '38')

          expected_result = Gun.where(caliber: '12').where(employee: nil)

          result = Gun.free('12')

          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
