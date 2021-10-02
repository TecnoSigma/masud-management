# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Customers::Orders::Escort, type: :mailer do
  describe 'renders the headers' do
    it 'renders #to' do
      order_number = '1234456'
      email = Faker::Internet.email

      result = described_class.scheduling(order_number: order_number, email: email).to

      expect(result).to eq([email])
    end

    it 'renders #subject' do
      order_number = '1234456'
      email = Faker::Internet.email

      result = described_class.scheduling(order_number: order_number, email: email).subject

      expect(result).to eq("Agendamento da Escolta #{order_number}")
    end

    it 'renders #from' do
      order_number = '1234456'
      email = Faker::Internet.email

      result = described_class.scheduling(order_number: order_number, email: email).from

      expect(result).to eq(['tecnooxossi@gmail.com'])
    end
  end
end
