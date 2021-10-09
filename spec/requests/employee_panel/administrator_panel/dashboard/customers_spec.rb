# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Customers', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#list' do
    it 'renders customers page' do
      get '/gestao/admin/dashboard/clientes'

      expect(response).to render_template(:list)
    end
  end

  describe '#new' do
    it 'renders customers page' do
      get '/gestao/admin/dashboard/cliente/novo'

      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when pass valid params' do
      it 'creates a new customer' do
        status = FactoryBot.create(:status, name: 'ativo')
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company, status: status.name)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        result = Customer.find_by_company(company)

        expect(result).to be_present
      end

      it 'redirects to customers list page' do
        status = FactoryBot.create(:status, name: 'ativo')
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company, status: status.name)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end

      it 'shows success message' do
        status = FactoryBot.create(:status, name: 'ativo')
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company, status: status.name)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        expect(flash[:notice]).to eq("Cliente #{company} criado com sucesso!")
      end
    end

    context 'when pass invalid params' do
      it 'no creates a new customer' do
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        result = Customer.find_by_company(company)

        expect(result).to be_nil
      end

      it 'redirects to new customer page' do
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_cliente_novo_path)
      end

      it 'shows error message' do
        company = 'XPTO S.A.'
        customer_params = FactoryBot.attributes_for(:customer, company: company)

        post '/gestao/admin/dashboard/cliente/create', params: { customer: customer_params }

        expect(flash[:alert]).to eq('Erro ao criar novo cliente!')
      end
    end
  end

  describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        customer = FactoryBot.create(:customer)

        get "/gestao/admin/dashboard/cliente/#{customer.id}"

        expect(response).to render_template(:show)
      end
    end

    context 'when customer is not found' do
      it 'redirects to customers list page' do
        get '/gestao/admin/dashboard/cliente/invalid_order_number'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/cliente/invalid_order_number'

        expect(flash[:alert]).to eq('Cliente não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to customers list page' do
        customer = FactoryBot.create(:customer)

        allow(Customer).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/cliente/#{customer.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)

        allow(Customer).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/cliente/#{customer.id}"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end
end
