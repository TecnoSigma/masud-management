# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#first_customer_name' do
    it 'returns first customer name' do
      first_name = 'ACME'
      customer_name = "#{first_name} S.A."

      result = helper.first_customer_name(customer_name)

      expect(result).to eq(first_name)
    end
  end

  describe '#first_company_name' do
    it 'returns first company name when pass customer token' do
      first_company_name = 'ACME'

      customer = FactoryBot.create(:customer, company: "#{first_company_name} S.A.")
      service_token = FactoryBot.create(:service_token, customer: customer)

      result = helper.first_name(service_token.token, :customer)

      expect(result).to eq(first_company_name)
    end

    it 'returns first employee name when pass employee token' do
      first_name = 'João'

      employee = FactoryBot.create(:employee, :agent, name: "#{first_name} da Silva Santos")
      service_token = FactoryBot.create(:service_token, employee: employee)

      result = helper.first_name(service_token.token, :employee)

      expect(result).to eq(first_name)
    end
  end

  describe '#convert_date_time' do
    it 'returns converted date in format dd/mm/yyyy - hh:mm:ss' do
      scheduling = FactoryBot.create(:order, :scheduled)

      expected_result = DateTime.parse(scheduling.job_day.to_s).strftime('%d/%m/%Y - %H:%M')

      result = helper.convert_date_time(scheduling.job_day)

      expect(result).to eq(expected_result)
    end
  end

  describe '#convert_date' do
    it 'returns converted date in format dd/mm/yyyy' do
      employee = FactoryBot.create(:employee, :admin)

      expected_result = employee.admission_date.strftime('%d/%m/%Y')

      result = helper.convert_date(employee.admission_date)

      expect(result).to eq(expected_result)
    end

    it 'returns empty string when pass empty string' do
      result = helper.convert_date('')

      expect(result).to eq('')
    end
  end

  describe '#order_color' do
    it 'returns font blue class when the order is scheduled' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = 'scheduled-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end

    it 'returns font green class when the order is confirmed' do
      order = FactoryBot.create(:order, :confirmed)

      expected_result = 'confirmed-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end

    it 'returns font red class when the order is refused' do
      order = FactoryBot.create(:order, :refused)

      expected_result = 'refused-order'

      result = helper.order_color(order)

      expect(result).to eq(expected_result)
    end
  end
end
