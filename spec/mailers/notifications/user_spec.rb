# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::User, type: :mailer do
  describe 'renders the headers' do
    it 'renders #to' do
      password = Faker::Internet.password
      email = Faker::Internet.email

      result = described_class.forgot_your_password(email: email, password: password).to

      expect(result).to eq([email])
    end

    it 'renders #subject' do
      password = Faker::Internet.password
      email = Faker::Internet.email

      result = described_class.forgot_your_password(email: email, password: password).subject

      expect(result).to eq('Masud Segurança - Senha de Acesso')
    end

    it 'renders #from' do
      password = Faker::Internet.password
      email = Faker::Internet.email

      result = described_class.forgot_your_password(email: email, password: password).from

      expect(result).to eq(['tecnosigmamasud@gmail.com'])
    end
  end
end
