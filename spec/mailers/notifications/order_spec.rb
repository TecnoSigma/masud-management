# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::Order, type: :mailer do
  describe 'renders the headers' do
    it 'renders #to' do
      order_number = Faker::Number.number(digits: 3)
      blocking_date = DateTime.now
      employee_name = 'João da Silva'

      allow(ServiceToken)
        .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

      result = described_class
               .warn_about_blocking(
                 order_number: order_number,
                 blocking_date: blocking_date,
                 employee_token: '123456'
               )
               .to

      expect(result).to eq(['tecnosigmamasud@gmail.com'])
    end

    it 'renders #subject' do
      order_number = Faker::Number.number(digits: 3)
      blocking_date = DateTime.now
      employee_name = 'João da Silva'

      allow(ServiceToken)
        .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

      result = described_class
               .warn_about_blocking(
                 order_number: order_number,
                 blocking_date: blocking_date,
                 employee_token: '123456'
               )
               .subject

      expect(result).to eq("Bloqueio da Ordem de Serviço #{order_number} (Excesso de Recusas)")
    end

    it 'renders #from' do
      order_number = Faker::Number.number(digits: 3)
      blocking_date = DateTime.now
      employee_name = 'João da Silva'

      allow(ServiceToken)
        .to receive_message_chain(:find_by_token, :employee, :name) { employee_name }

      result = described_class
               .warn_about_blocking(
                 order_number: order_number,
                 blocking_date: blocking_date,
                 employee_token: '123456'
               )
               .from

      expect(result).to eq(['tecnosigmamasud@gmail.com'])
    end
  end
end
