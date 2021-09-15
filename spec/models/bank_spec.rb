require 'rails_helper'

RSpec.describe Bank, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass COMPE register' do
      error_message = 'Preenchimento de campo obrigatório!'
      bank = FactoryBot.build(:bank, compe_register: nil)

      expect(bank.valid?).to be_falsey
      expect(bank.errors.messages[:compe_register]).to include(error_message)
    end

    it 'no validates when not pass name' do
      error_message = 'Preenchimento de campo obrigatório!'
      bank = FactoryBot.build(:bank, name: nil)

      expect(bank.valid?).to be_falsey
      expect(bank.errors.messages[:name]).to include(error_message)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Bank and Account' do
      bank = Bank.new

      expect(bank).to respond_to(:accounts)
    end
  end
end
