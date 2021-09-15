require 'rails_helper'

RSpec.describe Seller, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass name' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, name: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:name]).to include(error_message)
    end

    it 'no validates when not pass password' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, password: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:password]).to include(error_message)
    end

    it 'no validates when not pass code' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, code: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:code]).to include(error_message)
    end

    it 'no validates when not pass core_register' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, core_register: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:core_register]).to include(error_message)
    end

    it 'no validates when not pass seller CPF' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, document: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when not pass seller register expedition date' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, expedition_date: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:expedition_date]).to include(error_message)
    end

    it 'no validates when not pass seller register expiration date' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, expiration_date: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:expiration_date]).to include(error_message)
    end

    it 'no validates when not pass address' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, address: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:address]).to include(error_message)
    end

    it 'no validates when not pass number' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, number: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:number]).to include(error_message)
    end

    it 'no validates when not pass district' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, district: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:district]).to include(error_message)
    end

    it 'no validates when not pass city' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, city: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:city]).to include(error_message)
    end

    it 'no validates when not pass state' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, state: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:state]).to include(error_message)
    end

    it 'no validates when not pass postal code' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, postal_code: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:postal_code]).to include(error_message)
    end

    it 'no validates when not pass cellphone' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, cellphone: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:cellphone]).to include(error_message)
    end

    it 'no validates when not pass status' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, status: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:status]).to include(error_message)
    end

    it 'no validates when not pass LinkedIn url' do
      error_message = 'Preenchimento de campo obrigatório!'
      seller = FactoryBot.build(:seller, linkedin: nil)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:linkedin]).to include(error_message)
    end
  end

  describe 'validates REGEX' do
    it 'no validates when pass core_register with invalid REGEX' do
	    error_message = 'Formato inválido!'

      invalid_core_register  = '123/123'
      seller = FactoryBot.build(:seller, core_register: invalid_core_register)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:core_register]).to include(error_message)
    end

    it 'no validates when pass CPF with invalid REGEX' do
      error_message = 'Formato inválido!'
      invalid_cpf = '123456'
      seller = FactoryBot.build(:seller, document: invalid_cpf)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when pass email with invalid REGEX' do
      error_message = 'Formato inválido!'
      invalid_email = '123456'
      seller = FactoryBot.build(:seller, email: invalid_email)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:email]).to include(error_message)
    end

    it 'no validates when pass cellphone with invalid REGEX' do
      error_message     = 'Formato inválido!'
      invalid_cellphone = '123456'
      seller = FactoryBot.build(:seller, cellphone: invalid_cellphone)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:cellphone]).to include(error_message)
    end

    it 'no validates when pass postal code with invalid REGEX' do
      error_message    = 'Formato inválido!'
      invalid_postal_code = '123456'
      seller = FactoryBot.build(:seller, postal_code: invalid_postal_code)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:postal_code]).to include(error_message)
    end

    it 'no validates when pass LinkedIn URL with invalid REGEX' do
      error_message    = 'Formato inválido!'
      invalid_url = 'anything'
      seller = FactoryBot.build(:seller, linkedin: invalid_url)

      expect(seller.valid?).to be_falsey
      expect(seller.errors.messages[:linkedin]).to include(error_message)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Seller and Orders' do
      seller = Seller.new

      expect(seller).to respond_to(:orders)
    end

    it 'validates relationship 1:1 between Seller and Account' do
      seller = Seller.new

      expect(seller).to respond_to(:account)
    end

    it 'validates relationship 1:1 between Seller and Banck through Account' do
      seller = Seller.new

      expect(seller).to respond_to(:bank)
    end

    it 'validates relationship 1:N between Seller and Receipts' do
      seller = Seller.new

      expect(seller).to respond_to(:receipts)
    end
  end

  describe 'validate uniqueness' do
    it 'no validates when pass duplicated core register' do
      error_message = 'Código do CORE existente!'

      new_seller     = FactoryBot.create(:seller)
      another_seller = FactoryBot.build(:seller, core_register: new_seller.core_register)

      expect(another_seller.valid?).to be_falsey
      expect(another_seller.errors.messages[:core_register]).to include(error_message)
    end

   it 'no validates when pass duplicated CPF' do
      error_message = 'Documento existente!'

      new_seller = FactoryBot.create(:seller)
      another_seller = FactoryBot.build(:seller, document: new_seller.document)

      expect(another_seller.valid?).to be_falsey
      expect(another_seller.errors.messages[:document]).to include(error_message)
    end
  end

  describe 'validates scopes' do
    it 'returns only activated sellers' do
      activated_seller = FactoryBot.create(:seller, status: Status::STATUSES[:activated])
      deactivated_seller = FactoryBot.create(:seller, status: Status::STATUSES[:deactivated])

      expect(Seller.activated).to include(activated_seller)
      expect(Seller.activated).not_to include(deactivated_seller)
    end
  end

  describe '#active?' do                                                                                                                                                                  
    it 'returns \'true\' when seller is active' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      expect(seller.active?).to eq(true)
    end

    it 'returns \'false\' when seller isn\'t active' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:pendent]
      seller.save

      expect(seller.active?).to eq(false)
    end
  end

  describe '#hidden_email' do
    it 'hides seller email' do
      seller = FactoryBot.create(:seller, email: 'anything@gmail.com')

      expect(seller.hidden_email).to eq('a******@gmail.com')
    end
  end

  describe '#location' do
    it 'shows seller full address' do
      seller = FactoryBot.create(:seller)

      result = seller.location

      expect(result).to eq("#{seller.address}, #{seller.number} - #{seller.complement} - #{seller.district}")
    end
  end

  describe '.generate_code' do
    it 'creates seller code' do
      document = '123.456.789-00'

      result = Seller.generate_code(document)

      expected_result = 'seller-12345678900'

      expect(result).to eq(expected_result)
    end
  end

  describe '.generate_password' do
    it 'creates seller password' do

      result = Seller.generate_password

      expect(result).to be_a(String)
      expect(result.length).to eq(10)
    end
  end
end
