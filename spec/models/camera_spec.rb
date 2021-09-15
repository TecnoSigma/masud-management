require 'rails_helper'

RSpec.describe Camera, type: :model do                                                                                                                                      
  describe 'validates presence' do
   it 'no validates when not pass kind' do
     camera = FactoryBot.build(:camera, kind: nil)

     expect(camera).to be_invalid
     expect(camera.errors[:kind]).to include('Preenchimento de campo obrigatório!')
   end

   it 'no validates when not pass ip' do
      camera = FactoryBot.build(:camera, ip: nil)

      expect(camera).to be_invalid
      expect(camera.errors[:ip]).to include('Preenchimento de campo obrigatório!')
    end

    it 'no validates when not pass user' do
      camera = FactoryBot.build(:camera, user: nil)

      expect(camera).to be_invalid
      expect(camera.errors[:user]).to include('Preenchimento de campo obrigatório!')
    end 

    it 'no validates when not pass password' do
      camera = FactoryBot.build(:camera, password: nil)

      expect(camera).to be_invalid
      expect(camera.errors[:password]).to include('Preenchimento de campo obrigatório!')
    end 

    it 'no validates when not pass status' do
      camera = FactoryBot.build(:camera, status: nil)

      expect(camera).to be_invalid
      expect(camera.errors[:status]).to include('Preenchimento de campo obrigatório!')
    end
  end

  it 'no validates when initial user isn\'t default' do
    camera = FactoryBot.build(:camera, user: Faker::Internet.username)

    expect(camera).to be_invalid
    expect(camera.errors[:user]).to include('Usuário inválido!')
  end

  it 'no validates when initial functional field isn\'t default' do
    camera = FactoryBot.build(:camera, functional: true)

    expect(camera).to be_invalid
    expect(camera.errors[:functional]).to include('Dados inválidos!')
  end

  it 'no validates when a initial configured field isn\'t default' do
    camera = FactoryBot.build(:camera, configured: true)

    expect(camera).to be_invalid
    expect(camera.errors[:configured]).to include('Dados inválidos!')
  end

  it 'no validates when acquisition date is greater than current date' do
    camera = FactoryBot.build(:camera, acquisition_date: DateTime.tomorrow)

    expect(camera).to be_invalid
    expect(camera.errors[:acquisition_date]).to include('Data inválida!')
  end

  it 'no validates when initial status isn\'t deactivated' do
    camera = FactoryBot.build(:camera, status: Status::STATUSES[:activated])

    expect(camera).to be_invalid
    expect(camera.errors[:status]).to include('Status inválido!')
  end
  
  it 'validates relationship (1:1) between Camera and Kit' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    camera = FactoryBot.build(:camera, kit: kit)

    expect(camera).to be_valid
    expect(camera).to respond_to(:kit)
  end

  it 'creates a serial number of camera when not pass serial number' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    camera = FactoryBot.create(:camera, kit: kit, serial_number: nil)

    expect(camera.serial_number).to be_present
  end

  it 'creates a acquisition date of camera when not pass acquisition date' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    camera = FactoryBot.create(:camera, kit: kit, acquisition_date: nil)

    expect(camera.acquisition_date).to be_present
  end 

  it 'validates only with status activated or deactivated' do
    subscriber = FactoryBot.create(:subscriber)
    kit = FactoryBot.create(:kit, subscriber: subscriber)
    camera = FactoryBot.create(:camera, kit: kit)

    camera.status = Status::STATUSES[:activated]
    expect(camera).to be_valid
   
    camera.status = Status::STATUSES[:deactivated]
    expect(camera).to be_valid

    camera.status = Status::STATUSES[:pendent]
    expect(camera).to be_invalid

    camera.status = Status::STATUSES[:deleted]
    expect(camera).to be_invalid
  end
end
