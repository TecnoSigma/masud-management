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

  describe '#edit' do
    context 'when pass valid params' do
      it 'renders edit page' do
        customer = FactoryBot.create(:customer)

        get "/gestao/admin/dashboard/cliente/#{customer.id}/editar"

        expect(response).to render_template(:edit)
      end
    end

    context 'when customer is not found' do
      it 'redirects to customers list page' do
        get '/gestao/admin/dashboard/cliente/invalid_order_number/editar'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/cliente/invalid_order_number/editar'

        expect(flash[:alert]).to eq('Cliente não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to customers list page' do
        customer = FactoryBot.create(:customer)

        allow(Customer).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/cliente/#{customer.id}/editar"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)

        allow(Customer).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/cliente/#{customer.id}/editar"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
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

  describe '#update' do
    context 'when pass valid params' do
      it 'updates customer data' do
        new_email = 'aninha@acme.com.br'
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        result = Customer.find(customer.id).email

        expect(result).to eq(new_email)
      end

      it 'shows success message' do
        new_email = 'aninha@acme.com.br'
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        expect(flash[:notice]).to eq('Dados do cliente atualizados com sucesso!')
      end

      it 'redirects to customer page' do
        new_email = 'aninha@acme.com.br'
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        expect(response).to redirect_to(
          employee_panel_administrator_dashboard_customer_show_path(customer.id)
        )
      end
    end

    context 'when pass invalid params' do
      it 'no updates customer data' do
        new_email = ''
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        result = Customer.find(customer.id).email

        expect(result).not_to eq(new_email)
      end

      it 'shows errors message' do
        new_email = ''
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        expect(flash[:alert]).to eq('Falha ao atualizar dados!')
      end

      it 'redirects to customer page' do
        new_email = ''
        customer = FactoryBot.create(:customer)

        patch "/gestao/admin/dashboard/cliente/update/#{customer.id}",
              params: { customer: { email: new_email } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end
    end
  end

  describe '#remove' do
    context 'when pass valid params' do
      it 'remove logically a customer' do
        FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        result = Customer.find(customer.id).deleted_at

        expect(result).to be_present
      end

      it 'changes status to \'deletado\'' do
        activated_status = FactoryBot.create(:status, name: 'ativo')
        deleted_status = FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil, status: activated_status)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        result = Customer.find(customer.id).status

        expect(result).to eq(deleted_status)
      end

      it 'shows success message' do
        FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        expect(flash[:notice]).to eq("Cliente #{customer.company} removido com sucesso!")
      end

      it 'redirects to customer page' do
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end
    end

    context 'when customer isn\'t found' do
      it 'no removes customer' do
        customer = FactoryBot.create(:customer)

        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        result = Customer.find(customer.id).deleted_at

        expect(result).to be_nil
      end

      it 'shows errors message' do
        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        expect(flash[:alert]).to eq('Cliente não encontrado!')
      end

      it 'redirects to customer page' do
        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end
    end
  end
end
