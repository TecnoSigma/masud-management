require 'rails_helper'

RSpec.describe DeliveryTariff, type: :model do
  it 'no validates when federative_unit is null' do
    delivery_tariff = FactoryBot.build(:delivery_tariff, federative_unit: nil)

    expect(delivery_tariff).not_to be_valid
    expect(delivery_tariff.errors.messages[:federative_unit]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when destiny is null' do
    delivery_tariff = FactoryBot.build(:delivery_tariff, destiny: nil)

    expect(delivery_tariff).not_to be_valid
    expect(delivery_tariff.errors.messages[:destiny]).to include('Preenchimento de campo obrigatório!')
  end

  it 'no validates when kind is null' do
    delivery_tariff = FactoryBot.build(:delivery_tariff, kind: nil)

    expect(delivery_tariff).not_to be_valid
    expect(delivery_tariff.errors.messages[:kind]).to include('Preenchimento de campo obrigatório!')
  end


for i in 1..30 do
    it "no validates when kg_#{i} is null" do
      delivery_tariff = FactoryBot.build(:delivery_tariff, { "kg_#{i}" => nil }.symbolize_keys)

      expect(delivery_tariff).not_to be_valid
      expect(delivery_tariff.errors.messages["kg_#{i}".to_sym]).to include('Preenchimento de campo obrigatório!')
    end

    it "no validates when kg_#{i} isn\'t a float number" do
       delivery_tariff = FactoryBot.build(:delivery_tariff, { "kg_#{i}" => 'anything' }.symbolize_keys)

       expect(delivery_tariff).not_to be_valid
       expect(delivery_tariff.errors.messages["kg_#{i}".to_sym]).to include('Formato inválido!')
    end

    it "no validates when kg_#{i} isn\'t a positive number" do
       delivery_tariff = FactoryBot.build(:delivery_tariff, { "kg_#{i}" => -1.0 }.symbolize_keys)

       expect(delivery_tariff).not_to be_valid
       expect(delivery_tariff.errors.messages["kg_#{i}".to_sym]).to include('Formato inválido!')
    end
  end

  it "no validates when additional_kg is null" do
    delivery_tariff = FactoryBot.build(:delivery_tariff, additional_kg: nil)

    expect(delivery_tariff).not_to be_valid
    expect(delivery_tariff.errors.messages[:additional_kg]).to include('Preenchimento de campo obrigatório!')
  end

  it "no validates when additional_kg isn\'t a float number" do
     delivery_tariff = FactoryBot.build(:delivery_tariff, additional_kg: 'anything' )

     expect(delivery_tariff).not_to be_valid
     expect(delivery_tariff.errors.messages[:additional_kg]).to include('Formato inválido!')
  end

  it "no validates when additional_kg isn\'t a positive number" do
     delivery_tariff = FactoryBot.build(:delivery_tariff, additional_kg: -1.0)

     expect(delivery_tariff).not_to be_valid
     expect(delivery_tariff.errors.messages[:additional_kg]).to include('Formato inválido!')
  end
end
