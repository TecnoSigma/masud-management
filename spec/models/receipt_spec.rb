require 'rails_helper'

RSpec.describe Receipt, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass serial' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.build(:receipt, seller: seller, serial: nil)

      expect(receipt.valid?).to be_falsey
      expect(receipt.errors.messages[:serial]).to include(error_message)
    end

    it 'no validates when not pass credits' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.build(:receipt, seller: seller, credits: nil)

      expect(receipt.valid?).to be_falsey
      expect(receipt.errors.messages[:credits]).to include(error_message)
    end

    it 'no validates when not pass debits' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.build(:receipt, seller: seller, debits: nil)

      expect(receipt.valid?).to be_falsey
      expect(receipt.errors.messages[:debits]).to include(error_message)
    end

    it 'no validates when not pass period' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.build(:receipt, seller: seller, period: nil)

      expect(receipt.valid?).to be_falsey
      expect(receipt.errors.messages[:period]).to include(error_message)
    end
  end

  describe 'validates relationships' do
    it 'validate relationship (N:1) between Receipt and Seller' do
      receipt = Receipt.new

      expect(receipt).to respond_to(:seller)
    end
  end

  describe '.generate!' do
    it 'generates seller receipt when pass valid params' do
      seller = FactoryBot.create(:seller)

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      order = FactoryBot.create(:order,
                                subscription: subscription,
                                price: 5340.12,
                                seller: seller,
                                status: 'aprovado',
                                approved_at: DateTime.parse('31-01-2020'))

      result_1 = Receipt.generate!(seller: seller, date: DateTime.parse('01-02-2020'))
      result_2 = Receipt.last

      expect(result_1).to eq(true)
      expect(result_2.serial).to eq('A-1')
      expect(result_2.credits).to eq({ "services"=>5340.12 })
      expect(result_2.debits).to eq({"inss"=>747.62, "irrf"=>397.18})
      expect(result_2.period).to eq('Janeiro/2020')
      expect(result_2.seller).to eq(seller)
    end

    it 'no generate seller receipt when pass invalid params' do
      seller = FactoryBot.create(:seller)

      subscriber = FactoryBot.create(:subscriber)
      subscription = FactoryBot.create(:subscription, subscriber: subscriber)
      order = FactoryBot.create(:order,
                                subscription: subscription,
                                price: 5340.12,
                                seller: seller,
                                status: 'aprovado',
                                approved_at: DateTime.parse('31-01-2020'))

      allow(Tributes::Irrf).to receive(:employee) { raise StandardError }

      result = Receipt.generate!(seller: seller, date: DateTime.parse('01-02-2020'))

      expect(result).to eq(false)
    end
  end

  describe '#place' do
    it 'returns receipt place' do
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.create(:receipt,
                                  seller: seller,
                                  credits: { services: 100.0 },
                                  debits: { inss: 5.0, irrf: 5.0 },
                                  period: 'Janeiro/2020',
                                  created_at: DateTime.parse('31-01-2020'))

      result = Receipt.last.place
      expected_result = 'São Paulo, 31 de Janeiro de 2020.'

      expect(result).to eq(expected_result)
    end
  end

  describe '#amount_receivable' do
    it 'returns amount receivable' do
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.create(:receipt,
                                  seller: seller,
                                  credits: { services: 100.0 },
                                  debits: { inss: 5.0, irrf: 5.0 },
                                  period: 'Janeiro/2020',
                                  created_at: DateTime.parse('31-01-2020'))

      result = Receipt.last.amount_receivable
      expected_result = 90.0

      expect(result).to eq(expected_result)
    end
  end

  describe '#credit_subtotal' do
    it 'returns credit subtotal' do
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.create(:receipt,
                                  seller: seller,
                                  credits: { services: 100.0 },
                                  debits: { inss: 5.0, irrf: 5.0 },
                                  period: 'Janeiro/2020',
                                  created_at: DateTime.parse('31-01-2020'))

      result = Receipt.last.credit_subtotal
      expected_result = 100.0

      expect(result).to eq(expected_result)
    end
  end

  describe '#debit_subtotal' do
    it 'returns debit subtotal' do
      seller = FactoryBot.create(:seller)
      receipt = FactoryBot.create(:receipt,
                                  seller: seller,
                                  credits: { services: 100.0 },
                                  debits: { inss: 5.0, irrf: 5.0 },
                                  period: 'Janeiro/2020',
                                  created_at: DateTime.parse('31-01-2020'))

      result = Receipt.last.debit_subtotal
      expected_result = 10.0

      expect(result).to eq(expected_result)
    end
  end
end
