require 'rails_helper'

RSpec.describe Router, type: :model do
  describe 'validates presence' do
    it 'no validates when not pass operator' do
      router = FactoryBot.build(:router, operator: nil)

      expect(router).to be_invalid
      expect(router.errors[:operator]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass kind' do
      router = FactoryBot.build(:router, kind: nil)

      expect(router).to be_invalid
      expect(router.errors[:kind]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass user' do
      router = FactoryBot.build(:router, user: nil)

      expect(router).to be_invalid
      expect(router.errors[:user]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass password' do
      router = FactoryBot.build(:router, password: nil)

      expect(router).to be_invalid
      expect(router.errors[:password]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass IMEI' do
      router = FactoryBot.build(:router, imei: nil)

      expect(router).to be_invalid
      expect(router.errors[:imei]).to include('Preenchimento de campo obrigatório!')
    end
  end

  it 'no validates when initial functional field isn\'t default' do
    router = FactoryBot.build(:router, functional: true)

    expect(router).to be_invalid
    expect(router.errors[:functional]).to include('Dados inválidos!')
  end

  it 'no validates when a initial configured field isn\'t default' do
    router = FactoryBot.build(:router, configured: true)

    expect(router).to be_invalid
    expect(router.errors[:configured]).to include('Dados inválidos!')
  end

  it 'no validates when acquisition date is greater than current date' do
    router = FactoryBot.build(:router, acquisition_date: DateTime.tomorrow)

    expect(router).to be_invalid
    expect(router.errors[:acquisition_date]).to include('Data inválida!')
  end

  it 'no validates when initial status isn\'t deactivated' do
    router = FactoryBot.build(:router, status: Status::STATUSES[:activated])

    expect(router).to be_invalid
    expect(router.errors[:status]).to include('Status inválido!')
  end
  
  it 'validates relationship (1:1) between Router and Kit' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    router = FactoryBot.build(:router, kit: kit)

    expect(router).to be_valid
    expect(router).to respond_to(:kit)
  end

  it 'creates a serial number of router when not pass serial number' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    router = FactoryBot.create(:router, kit: kit, serial_number: nil)

    expect(router.serial_number).to be_present
  end 

  it 'creates a acquisition date of router when not pass acquisition date' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    router = FactoryBot.create(:router, kit: kit, acquisition_date: nil)

    expect(router.acquisition_date).to be_present
  end

  it 'validates only with status activated or deactivated' do
    subscriber_1 = FactoryBot.create(:subscriber)
    kit_1 = FactoryBot.create(:kit, subscriber: subscriber_1)
    router = FactoryBot.create(:router, kit: kit_1)

    router.status = Status::STATUSES[:activated]
    expect(router).to be_valid
   
    router.status = Status::STATUSES[:deactivated]
    expect(router).to be_valid

    router.status = Status::STATUSES[:pendent]
    expect(router).to be_invalid

    router.status = Status::STATUSES[:deleted]
    expect(router).to be_invalid
  end
end
