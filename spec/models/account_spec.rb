require 'rails_helper'

RSpec.describe Account, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass agency' do
      error_message = 'Preenchimento de campo obrigatório!'
      account = FactoryBot.build(:account, agency: nil)

      expect(account.valid?).to be_falsey
      expect(account.errors.messages[:agency]).to include(error_message)
    end

    it 'no validates when not pass number' do
      error_message = 'Preenchimento de campo obrigatório!'
      account = FactoryBot.build(:account, number: nil)

      expect(account.valid?).to be_falsey
      expect(account.errors.messages[:number]).to include(error_message)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship 1:1 between Account and Seller' do
      account = Account.new

      expect(account).to respond_to(:seller)
    end

    it 'validates relationship N:1 between Account and Bank' do
      account = Account.new

      expect(account).to respond_to(:bank)
    end
  end
end
