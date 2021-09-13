# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel', type: :request do
  describe '#main' do
    context 'when not exists employee token' do
      it 'redirects to login page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { false }

        get '/painel_administrativo/main'

        expect(response).to redirect_to(employee_panel_login_path)
      end
    end

    context 'when exists employee token' do
      it 'redirects to index page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }

        get '/painel_administrativo/main'

        expect(response).to render_template(:main)
      end
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/painel_administrativo/login'

      expect(response).to render_template(:login)
    end
  end

  describe '#check_credentials' do
    context 'when employee is active' do
      it 'redirects to employee dashboard page' do
        status = FactoryBot.create(:status, name: 'ativo')
        employee = FactoryBot.create(:employee, status: status)

        post '/painel_administrativo/check_credentials',
             params: { employee: { email: employee.email, password: employee.password } }

        expect(response).to redirect_to(employee_panel_main_path)
      end

      it 'creates employee token' do
        status = FactoryBot.create(:status, name: 'ativo')
        employee = FactoryBot.create(:employee, status: status)

        post '/painel_administrativo/check_credentials',
             params: { employee: { email: employee.email, password: employee.password } }

        result = session[:employee_token]

        expect(result).to be_present
      end
    end

    context 'when employee is not found' do
      it 'redirects to employee login page' do
        post '/painel_administrativo/check_credentials',
             params: { employee: { email: 'any email', password: 'any password' } }

        expect(response).to redirect_to(employee_panel_login_path)
      end

      it 'shows error message' do
        post '/painel_administrativo/check_credentials',
             params: { employee: { email: 'any email', password: 'any password' } }

        expect(flash[:alert]).to eq('Email e/ou senha inválidos!')
      end
    end

    context 'when employee isn\'t authorized' do
      it 'redirects to employee login page' do
        status = FactoryBot.create(:status, name: 'desativado')
        employee = FactoryBot.create(:employee, status: status)

        post '/painel_administrativo/check_credentials',
             params: { employee: { email: employee.email, password: employee.password } }

        expect(response).to redirect_to(employee_panel_login_path)
      end

      it 'shows error message' do
        status = FactoryBot.create(:status, name: 'desativado')
        employee = FactoryBot.create(:employee, status: status)

        post '/painel_administrativo/check_credentials',
             params: { employee: { email: employee.email, password: employee.password } }

        expect(flash[:alert]).to eq('Seu status atual não lhe permite o acesso. Por favor, contate-nos!')
      end
    end
  end
end
