# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  include ApplicationHelper

  describe '#boolean_options' do
    it 'returns arrays of array containing boolean values' do
      expected_result = [['Sim', true], ['Não', false]]

      result = helper.boolean_options

      expect(result).to eq(expected_result)
    end
  end

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

  describe '#full_address' do
    it 'returns source full address of order' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = "#{order.source_address}, #{order.source_number} - " \
                        "#{order.source_district} - #{order.source_city} - #{order.source_state}"

      result = helper.full_address(order, :source)

      expect(result).to eq(expected_result)
    end

    it 'returns destiny full address of order' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = "#{order.destiny_address}, #{order.destiny_number} - " \
                        "#{order.destiny_district} - #{order.destiny_city} - #{order.destiny_state}"

      result = helper.full_address(order, :destiny)

      expect(result).to eq(expected_result)
    end
  end

  describe '#date_time' do
    it 'convert to date/time of job' do
      order = FactoryBot.create(:order, :scheduled)

      expected_result = "#{order.job_day} - #{order.job_horary}"

      result = helper.date_time(order)

      expect(result).to eq(expected_result)
    end
  end

  describe '#free_items' do
    it 'counts free guns (caliber 38) when pass gun type' do
      guns_quantity = 10

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:arsenal, :gun, caliber: '38', employee: employee)
      FactoryBot.create_list(:arsenal, guns_quantity, :gun, caliber: '38', employee: nil)

      result = helper.free_items(:gun, '38')

      expected_result = (0..guns_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts free guns (caliber 12) when pass gun type' do
      guns_quantity = 10

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:arsenal, :gun, caliber: '12', employee: employee)
      FactoryBot.create_list(:arsenal, guns_quantity, :gun, caliber: '12', employee: nil)

      result = helper.free_items(:gun, '12')

      expected_result = (0..guns_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts free waistcoats when pass waistcoat type' do
      waistcoats_quantity = 50

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:tackle, :waistcoat, employee: employee)
      FactoryBot.create_list(:tackle, waistcoats_quantity, :waistcoat, employee: nil)

      result = helper.free_items(:waistcoat)

      expected_result = (0..waistcoats_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts free radios when pass radio type' do
      radios_quantity = 2

      employee = FactoryBot.create(:employee, :agent)
      FactoryBot.create(:tackle, :radio, employee: employee)
      FactoryBot.create_list(:tackle, radios_quantity, :radio, employee: nil)

      result = helper.free_items(:radio)

      expected_result = (0..radios_quantity).to_a

      expect(result).to eq(expected_result)
    end

    it 'counts free vehicles when pass radio type' do
      vehicles_quantity = 10

      team = FactoryBot.create(:team)
      FactoryBot.create(:vehicle, team: team)
      FactoryBot.create_list(:vehicle, vehicles_quantity, team: nil)

      result = helper.free_items(:vehicle)

      expected_result = (0..vehicles_quantity).to_a

      expect(result).to eq(expected_result)
    end
  end
end
