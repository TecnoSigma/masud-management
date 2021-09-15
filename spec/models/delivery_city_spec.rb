require 'rails_helper'

RSpec.describe DeliveryCity, type: :model do
  it 'no validates when federative unit is null' do
    city = FactoryBot.build(:delivery_city, federative_unit: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:federative_unit]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when locality is null' do
    city = FactoryBot.build(:delivery_city, locality: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:locality]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when initial postal code is null' do
    city = FactoryBot.build(:delivery_city, initial_postal_code: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:initial_postal_code]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when final postal code is null' do
    city = FactoryBot.build(:delivery_city, final_postal_code: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:final_postal_code]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when express time is null' do
    city = FactoryBot.build(:delivery_city, express_time: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:express_time]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when road time is null' do
    city = FactoryBot.build(:delivery_city, road_time: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:road_time]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when price is null' do
    city = FactoryBot.build(:delivery_city, price: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:price]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when distributor is null' do
    city = FactoryBot.build(:delivery_city, distributor: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:distributor]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when risk group is null' do
    city = FactoryBot.build(:delivery_city, risk_group: nil)

    expect(city).not_to be_valid
    expect(city.errors.messages[:risk_group]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when express time isn\'t number' do
    city = FactoryBot.build(:delivery_city, express_time: 'anything')

    expect(city).not_to be_valid
    expect(city.errors.messages[:express_time]).to include('Formato inválido!')
  end

  it 'no validates when road time isn\'t number' do
    city = FactoryBot.build(:delivery_city, road_time: 'anything')

    expect(city).not_to be_valid
    expect(city.errors.messages[:road_time]).to include('Formato inválido!')
  end

  it 'no validates when risk group isn\'t number' do
    city = FactoryBot.build(:delivery_city, risk_group: 'anything')

    expect(city).not_to be_valid
    expect(city.errors.messages[:risk_group]).to include('Formato inválido!')
  end
end
