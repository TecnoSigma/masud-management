# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
  describe '#main' do
    context 'when not exists customer token' do
      it 'redirects to login page' do
        allow_any_instance_of(CustomerPanelController).to receive(:tokenized?) { false }

        get '/painel_do_cliente/main'

        expect(response).to redirect_to(customer_panel_login_path)
      end
    end

    context 'when exists customer token' do
      it 'redirects to index page' do
        allow_any_instance_of(CustomerPanelController).to receive(:tokenized?) { true }

        get '/painel_do_cliente/main'

        expect(response).to render_template(:main)
      end
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/painel_do_cliente/login'

      expect(response).to render_template(:login)
    end
  end

  describe '#check_credentials' do
    context 'when customer is active' do
      it 'redirects to customer dashboard page' do
        status = FactoryBot.create(:status, name: 'ativo')
        customer = FactoryBot.create(:customer, status: status)

        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(response).to redirect_to(customer_panel_main_path)
      end

      it 'creates customer token' do
        status = FactoryBot.create(:status, name: 'ativo')
        customer = FactoryBot.create(:customer, status: status)

        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        result = session[:customer_token]

        expect(result).to be_present
      end
    end

    context 'when customer is not found' do
      it 'redirects to customer login page' do
        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: 'any email', password: 'any password' } }

        expect(response).to redirect_to(customer_panel_login_path)
      end

      it 'shows error message' do
        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: 'any email', password: 'any password' } }

        expect(flash[:alert]).to eq('Email e/ou senha inválidos!')
      end
    end

    context 'when customer isn\'t authorized' do
      it 'redirects to customer login page' do
        status = FactoryBot.create(:status, name: 'desativado')
        customer = FactoryBot.create(:customer, status: status)

        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(response).to redirect_to(customer_panel_login_path)
      end

      it 'shows error message' do
        status = FactoryBot.create(:status, name: 'desativado')
        customer = FactoryBot.create(:customer, status: status)

        post '/painel_do_cliente/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(flash[:alert]).to eq('Seu status atual não lhe permite o acesso. Por favor, contate-nos!')
      end
    end
  end
end
