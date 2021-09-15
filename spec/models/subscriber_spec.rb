require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  describe 'validate required fields' do
    it 'no validates when not pass name' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, name: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:name]).to include(error_message)
    end

    it 'no validates when not pass document' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, document: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when not pass subscriber kind' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, kind: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:kind]).to include(error_message)
    end

    it 'no validates when not pass address' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, address: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:address]).to include(error_message)
    end

    it 'no validates when not pass number' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, number: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:number]).to include(error_message)
    end

    it 'no validates when not pass district' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, district: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:district]).to include(error_message)
    end

    it 'no validates when not pass city' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, city: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:city]).to include(error_message)
    end

    it 'no validates when not pass state' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, state: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:state]).to include(error_message)
    end

    it 'no validates when not pass postal code' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, postal_code: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:postal_code]).to include(error_message)
    end

    it 'no validates when not pass IP' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, ip: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:ip]).to include(error_message)
    end

    it 'no validates when not pass telephone' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, telephone: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:telephone]).to include(error_message)
    end

    it 'no validates when not pass cellphone' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, cellphone: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:cellphone]).to include(error_message)
    end

    it 'no validates when not pass user' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, user: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:user]).to include(error_message)
    end

    it 'no validates when not pass password' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, password: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:password]).to include(error_message)
    end

    it 'no validates when not pass status' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, status: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:status]).to include(error_message)
    end

    it 'no validates when not pass responsible cpf if subscriber is a company' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, kind: 'PJ', responsible_cpf: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:responsible_cpf]).to include(error_message)
    end

    it 'no validates when not pass responsible name if subscriber is a company' do
      error_message = 'Preenchimento de campo obrigatório!'
      subscriber = FactoryBot.build(:subscriber, kind: 'PJ', responsible_name: nil)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:responsible_name]).to include(error_message)
    end
  end

  describe 'validates REGEX' do
    it 'no validates when pass kind with invalid REGEX' do
      error_message = 'Formato inválido!'

      invalid_kind  = '123'
      subscriber = FactoryBot.build(:subscriber, kind: invalid_kind)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:kind]).to include(error_message)
    end

    it 'no validates when pass document with invalid REGEX and subscriber is a company' do
      error_message = 'Formato inválido!'
      invalid_document  = '123456'
      subscriber = FactoryBot.build(:subscriber, kind: 'PJ', document: invalid_document)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when pass document with invalid REGEX and subscriber isn\'t from a company' do
      error_message = 'Formato inválido!'
      invalid_document  = '123456'
      subscriber = FactoryBot.build(:subscriber, kind: 'PF',  document: invalid_document)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when pass responsible CPF with invalid REGEX and subscriber is a company' do
      error_message = 'Formato inválido!'
      invalid_cpf = '123456'
      subscriber = FactoryBot.build(:subscriber, kind: 'PJ', responsible_cpf: invalid_cpf)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:responsible_cpf]).to include(error_message)
    end

    it 'no validates when pass email with invalid REGEX' do
      error_message = 'Formato inválido!'
      invalid_email = '123456'
      subscriber = FactoryBot.build(:subscriber, email: invalid_email)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:email]).to include(error_message)
    end

    it 'no validates when pass telephone with invalid REGEX' do
      error_message     = 'Formato inválido!'
      invalid_telephone = '123456'
      subscriber = FactoryBot.build(:subscriber, telephone: invalid_telephone)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:telephone]).to include(error_message)
    end

    it 'no validates when pass cellphone with invalid REGEX' do
      error_message     = 'Formato inválido!'
      invalid_cellphone = '123456'
      subscriber = FactoryBot.build(:subscriber, cellphone: invalid_cellphone)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:cellphone]).to include(error_message)
    end

    it 'no validates when pass user with invalid REGEX' do
      error_message = 'Formato inválido!'
      invalid_user  = '123'
      subscriber = FactoryBot.build(:subscriber, user: invalid_user)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:user]).to include(error_message)
    end

    it 'no validates when pass postal code with invalid REGEX' do
      error_message    = 'Formato inválido!'
      invalid_postal_code = '123456'
      subscriber = FactoryBot.build(:subscriber, postal_code: invalid_postal_code)

      expect(subscriber.valid?).to be_falsey
      expect(subscriber.errors.messages[:postal_code]).to include(error_message)
    end
  end

  describe 'validates relationships' do
    it 'validates relationship 1:N between Subscriber and Vehicles' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:vehicles)
    end

    it 'validates relationship 1:1 between Subscriber and Kit' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:kit)
    end

    it 'validates relationship N:1 between Subscriber and Plan' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:plan)
    end

    it 'validates relationship 1:N between Subscriber and Subscription' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:subscriptions)
    end

    it 'validates relationship 1:N between Subscriber and Angel' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:angels)
    end

    it 'validates relationship 1:1 between Subscriber and Camera through of Kit' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:camera)
    end

    it 'validates relationship 1:1 between Subscriber and Router through of Kit' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:router)
    end

    it 'validates relationship 1:N between Subscriber and Ticket' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:tickets)
    end

    it 'validates relationship 1:N between Subscriber and Drivers through Vehicles' do
      subscriber = Subscriber.new

      expect(subscriber).to respond_to(:drivers)
    end
  end

  describe 'validate uniqueness' do
    it 'no validates when pass duplicated user' do
      error_message = 'Usuário existente!'

      new_subscriber     = FactoryBot.create(:subscriber)
      another_subscriber = FactoryBot.build(:subscriber, user: new_subscriber.user)

      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:user]).to include(error_message)
    end

    it 'no validates when pass duplicated document from a activated subscriber' do
      error_message = 'Documento existente!'

      new_subscriber = FactoryBot.create(:subscriber)
      new_subscriber.update_attributes!(status: Status::STATUSES[:activated] )
      another_subscriber = FactoryBot.build(:subscriber, document: new_subscriber.document)

      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when pass duplicated document from a pendent subscriber' do
      error_message = 'Documento existente!'

      new_subscriber     = FactoryBot.create(:subscriber, status: Status::STATUSES[:pendent] )
      another_subscriber = FactoryBot.build(:subscriber, document: new_subscriber.document)

      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:document]).to include(error_message)
    end

   it 'no validates when pass duplicated document from a deactivated subscriber' do
      error_message = 'Documento existente!'

      new_subscriber = FactoryBot.create(:subscriber)
      new_subscriber.update_attributes!(status: Status::STATUSES[:deactivated] )
      another_subscriber = FactoryBot.build(:subscriber, document: new_subscriber.document)

      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:document]).to include(error_message)
    end
  end

    it 'no validates when pass duplicated document and subscriber is a company' do
      error_message = 'Documento existente!'

      new_subscriber     = FactoryBot.create(:subscriber, kind: 'PJ')
      another_subscriber = FactoryBot.build(:subscriber, document: new_subscriber.document)

      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:document]).to include(error_message)
    end

    it 'no validates when pass duplicated document and subscriber isn\'t a company' do
      error_message = 'Documento existente!'

      new_subscriber     = FactoryBot.create(:subscriber, kind: 'PF')
      another_subscriber = FactoryBot.build(:subscriber, document: new_subscriber.document)
      expect(another_subscriber.valid?).to be_falsey
      expect(another_subscriber.errors.messages[:document]).to include(error_message)
    end

  it 'validates when a subscriber is created with status pendent' do
    error_message = 'Status inválido!'

    subscriber = FactoryBot.build(:subscriber, status: Status::STATUSES[:pendent])

    expect(subscriber.valid?).to eq(true)
    expect(subscriber.errors.messages[:status]).not_to include(error_message)
  end

  it 'no validates when the subscriber user have less than allowed character quantity' do
    error_message = 'Quantidade de caracteres inválidos!'
    
    subscriber = FactoryBot.build(:subscriber, user: '123')

    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:user]).to include(error_message)
  end

  it 'no validates when the subscriber user have greater than allowed character quantity' do
    error_message = 'Quantidade de caracteres inválidos!'
    
    subscriber = FactoryBot.build(:subscriber, user: '123456789101112131415')
    
    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:user]).to include(error_message)
  end

  it 'no validates when the subscriber password have less than allowed character quantity' do
    error_message = 'Quantidade de caracteres inválidos!'
    
    subscriber = FactoryBot.build(:subscriber, password: '123')
    
    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:password]).to include(error_message)
  end                                                                                      
  
  it 'no validates when the subscriber password have greater than allowed character quantity' do
    error_message = 'Quantidade de caracteres inválidos!'
    
    subscriber = FactoryBot.build(:subscriber, password: '1234567891011121314151617181920')
    
    expect(subscriber).to be_invalid
    expect(subscriber.errors.messages[:password]).to include(error_message)
  end

  it 'returns subscriber code' do
    document = '12.345.678/0001-99'

    expected_result = 'subscriber-12345678000199'

    expect(described_class.code(document)).to eq(expected_result)
  end

  it 'returns subscriber email' do
    email = 'any_@any.com.br'

    expect(described_class.email(email)).to eq(email)
  end

  it 'returns subscriber fullname' do
    responsible_name = 'João da Silva'

    expect(described_class.fullname(responsible_name)).to eq(responsible_name)
  end

  it 'returns subscriber cpf' do
    cpf = '123.456.789-00'

    expected_result = '12345678900'

    expect(described_class.cpf(cpf)).to eq(expected_result)
  end

  it 'returns subscriber phone area code' do
    phone = '(12) 4566 1200'

    expected_result = '12'
    
    expect(described_class.phone_area_code(phone)).to eq(expected_result)
  end

  it 'returns subscriber phone number' do
    phone = '(12) 4566 1200'

    expected_result = '45661200'

    expect(described_class.phone_number(phone)).to eq(expected_result)
  end

  it 'returns subscriber birthdate day' do
    date = DateTime.now

    expected_result = date.day

    expect(described_class.birthdate_day(date)).to eq(expected_result)
  end

  it 'returns subscriber birthdate month' do
    date = DateTime.now

    expected_result = date.month

    expect(described_class.birthdate_month(date)).to eq(expected_result)
  end

  it 'returns subscriber birthdate year' do
    date = DateTime.now

    expected_result = date.year

    expect(described_class.birthdate_year(date)).to eq(expected_result)
  end

  it 'returns subscriber address street' do
    street = 'Rua do Centro'

    expect(described_class.street(street)).to eq(street)
  end

  it 'returns subscriber address number' do
    number = '120'

    expect(described_class.number(number)).to eq(number)
  end

  it 'returns subscriber address complement' do
    complement = 'casa 1'

    expect(described_class.complement(complement)).to eq(complement)
  end

  it 'returns subscriber address district' do
    district = 'Centro'

    expect(described_class.district(district)).to eq(district)
  end

  it 'returns subscriber address city' do
    city = 'São Paulo'

    expect(described_class.city(city)).to eq(city)
  end

  it 'returns subscriber address state' do
    state = 'São Paulo'

    expected_result = 'SP'

    expect(described_class.state(state)).to eq(expected_result)
  end

  it 'returns subscriber address postal code' do
    postal_code  = '04582-234'

    expected_result = '04582234'
    
    expect(described_class.postal_code(postal_code)).to eq(expected_result)
  end

  it 'returns subscriber credit card holder name' do
    holder_name = 'joao da silva'

    expected_result = 'JOAO DA SILVA'

    expect(described_class.holder_name(holder_name)).to eq(expected_result)
  end

  it 'returns subscriber credit card number' do
    credit_card_number = '5491422298649238'

    expect(described_class.credit_card_number(credit_card_number)).to eq(credit_card_number)
  end

  it 'returns subscriber credit card expiration month' do
    expiration_month = '12'

    expect(described_class.expiration_month(expiration_month)).to eq(expiration_month)
  end

  it 'returns subscriber credit card expiration year' do
    expiration_year = '2050'

    expected_result = '50'

    expect(described_class.expiration_year(expiration_year)).to eq(expected_result)
  end

  describe '#active?' do
    it 'returns \'true\' when subscriber is active' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      expect(subscriber.active?).to eq(true)
    end

    it 'returns \'false\' when subscriber isn\'t active' do
      subscriber = FactoryBot.create(:subscriber)

      expect(subscriber.active?).to eq(false)
    end
  end

  describe '#hidden_email' do
    it 'hides subscriber email' do
      subscriber = FactoryBot.create(:subscriber, email: 'anything@gmail.com')

      expect(subscriber.hidden_email).to eq('a******@gmail.com')
    end
  end

  describe '#allowed_status?' do
    it 'no validates when pass invalid status' do
      error_message = 'Status inválido!' 

      subscriber = FactoryBot.build(:subscriber, status: 'anything')

      expect(subscriber).to be_invalid
      expect(subscriber.errors.messages[:status]).to include(error_message)
    end
  end

  describe '#have_vehicle_photos' do
    it 'returns \'true\' when subscriber have vehicle that have photos' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      result = subscriber.have_vehicle_photos?

      expect(result).to eq(true)
    end

    it 'returns \'false\' when subscriber have vehicle that haven\'t photos' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      result = subscriber.have_vehicle_photos?

      expect(result).to eq(false)
    end
  end
end
