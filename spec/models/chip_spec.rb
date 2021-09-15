require 'rails_helper'

RSpec.describe Chip, type: :model do
  describe 'validates presence' do
    it 'no validates when not pass kind' do
      chip = FactoryBot.build(:chip, kind: nil)

      expect(chip).to be_invalid
      expect(chip.errors[:kind]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass status' do
      chip = FactoryBot.build(:chip, kind: nil)

      expect(chip).to be_invalid
      expect(chip.errors[:kind]).to include('Preenchimento de campo obrigatório!')
    end
  end

  it 'no validates when initial functional field isn\'t default' do
    chip = FactoryBot.build(:chip, functional: true)

    expect(chip).to be_invalid
    expect(chip.errors[:functional]).to include('Dados inválidos!')
  end

  it 'no validates when a initial configured field isn\'t default' do
    chip = FactoryBot.build(:chip, configured: true)

    expect(chip).to be_invalid
    expect(chip.errors[:configured]).to include('Dados inválidos!')
  end

  it 'no validates when acquisition date is greater than current date' do
    chip = FactoryBot.build(:chip, acquisition_date: DateTime.tomorrow)

    expect(chip).to be_invalid
    expect(chip.errors[:acquisition_date]).to include('Data inválida!')
  end

  it 'no validates when initial status isn\'t deactivated' do
    chip = FactoryBot.build(:chip, status: Status::STATUSES[:activated])

    expect(chip).to be_invalid
    expect(chip.errors[:status]).to include('Status inválido!')
  end

  it 'validates relationship (1:1) between Chip and Kit' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    chip = FactoryBot.build(:chip, kit: kit)

    expect(chip).to be_valid
    expect(chip).to respond_to(:kit)
  end

  it 'creates a serial number of chip when not pass serial number' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    chip = FactoryBot.create(:chip, kit: kit, serial_number: nil)

    expect(chip.serial_number).to be_present
  end 

  it 'creates a acquisition date of chip when not pass acquisition date' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    chip = FactoryBot.create(:chip, kit: kit, acquisition_date: nil)

    expect(chip.acquisition_date).to be_present
  end 

  it 'validates only with status activated or deactivated' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    chip = FactoryBot.create(:chip, kit: kit)

    chip.status = Status::STATUSES[:activated]
    expect(chip).to be_valid

    chip.status = Status::STATUSES[:deactivated]
    expect(chip).to be_valid

    chip.status = Status::STATUSES[:pendent]
    expect(chip).to be_invalid

    chip.status = Status::STATUSES[:deleted]
    expect(chip).to be_invalid
  end
end
