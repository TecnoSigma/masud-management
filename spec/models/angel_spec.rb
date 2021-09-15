require 'rails_helper'

RSpec.describe Angel, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass name' do
      error_message = 'Preenchimento de campo obrigatório!'
      angel = FactoryBot.build(:angel, name: nil)

      expect(angel.valid?).to be_falsey
      expect(angel.errors.messages[:name]).to include(error_message)
    end

    it 'no validates when not pass cpf' do
      error_message = 'Preenchimento de campo obrigatório!'
      angel = FactoryBot.build(:angel, cpf: nil)

      expect(angel.valid?).to be_falsey
      expect(angel.errors.messages[:cpf]).to include(error_message)
    end

     it 'no validates when not pass status' do
      error_message = 'Preenchimento de campo obrigatório!'
      angel = FactoryBot.build(:angel, status: nil)

      expect(angel.valid?).to be_falsey
      expect(angel.errors.messages[:status]).to include(error_message)
    end
  end
 
  describe 'validates relationships' do                                                    
    it 'validates relationship N:1 between Angel and Subscriber' do
      angel = Angel.new

      expect(angel).to respond_to(:subscriber)
    end

    it 'validates relationship N:N between Angel and Driver' do
      angel = Angel.new

      expect(angel).to respond_to(:drivers)
    end
  end 

  describe 'validates REGEX' do
    it 'no validates when pass CPF with invalid REGEX' do
      error_message = 'Formato inválido!'
      invalid_cpf = '123456'
      subscriber = FactoryBot.build(:angel, cpf: invalid_cpf)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:cpf]).to include(error_message)
    end
  end

  describe '#allowed_status?' do
    it 'no validates when pass invalid status' do
      error_message = 'Status inválido!'

      angel = FactoryBot.build(:angel, status: 'anything')

      expect(angel).to be_invalid
      expect(angel.errors.messages[:status]).to include(error_message)
    end
  end

  describe 'validates scopes' do
    it 'returns angel list ordered by name' do
      Subscriber.delete_all
      Plan.delete_all
      Angel.delete_all

      subscriber = FactoryBot.create(:subscriber)

      angel_1 = FactoryBot.create(:angel, name: 'Ze dos Santos', subscriber: subscriber)
      angel_2 = FactoryBot.create(:angel, name: 'Abel da Silva', subscriber: subscriber)

      expected_result = [angel_2, angel_1]

      expect(Angel.sort_by_name).to eq(expected_result)
    end

    it 'returns only activated angel' do
      Subscriber.delete_all
      Plan.delete_all
      Angel.delete_all

      subscriber = FactoryBot.create(:subscriber)

      angel_1 = FactoryBot.create(:angel, name: 'Ze dos Santos', subscriber: subscriber, status: Status::STATUSES[:deactivated])
      angel_2 = FactoryBot.create(:angel, name: 'Abel da Silva', subscriber: subscriber)

      expect(Angel.active).to eq([angel_2])
    end
  end

  describe '.activated_protected' do
    it 'returns only activated protected names' do
      Subscriber.delete_all
      Plan.delete_all
      Angel.delete_all

      plan = FactoryBot.create(:plan)
      subscriber_1 = FactoryBot.create(:subscriber, name: 'Zuza', plan: plan)
      subscriber_1.status = Status::STATUSES[:activated]
      subscriber_1.save!

      subscriber_2 = FactoryBot.create(:subscriber, name: 'Ana', plan: plan)
      subscriber_2.status = Status::STATUSES[:activated]
      subscriber_2.save!

      document = '123.456.789-00'

      FactoryBot.create(:angel, name: 'João da Silva', cpf: document, subscriber: subscriber_1)
      FactoryBot.create(:angel, name: 'João da Silva', cpf: document, subscriber: subscriber_2)

      result = Angel.activated_protected(document)

      expect(result).to eq ([[subscriber_2.code, subscriber_2.name], [subscriber_1.code, subscriber_1.name]])
    end
  end

  describe '#activated?' do
    it "returns 'true' when angel is activated" do
      subscriber = FactoryBot.create(:subscriber)

      angel = FactoryBot.create(:angel, status: 'ativado', subscriber: subscriber)

      expect(angel.activated?).to eq(true)
    end

    it "returns 'false' when angel is deactivated" do
      Subscriber.delete_all
      Plan.delete_all
      Angel.delete_all

      subscriber = FactoryBot.create(:subscriber)
      angel = FactoryBot.create(:angel, status: 'desativado', subscriber: subscriber)

      expect(angel.activated?).to eq(false)
    end
  end
end
