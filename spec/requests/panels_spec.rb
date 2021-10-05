# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Panel', type: :request do
  describe '#send_password' do
    context 'when user is a customer' do
      context 'and pass valid params' do
        it 'redirects to forgot your password page' do
          customer = FactoryBot.create(:customer)

          allow(Notifications::User)
            .to receive_message_chain(:forgot_your_password, :deliver_now!) { true }

          post '/send_password', params: { user: { email: customer.email } }

          expect(response).to redirect_to(cliente_esqueceu_sua_senha_path)
        end

        it 'shows success message' do
          customer = FactoryBot.create(:customer)

          allow(Notifications::User)
            .to receive_message_chain(:forgot_your_password, :deliver_now!) { true }

          post '/send_password', params: { user: { email: customer.email } }

          expect(flash[:notice]).to eq('Senha enviada com sucesso!')
        end
      end

      context 'and pass user is not found' do
        it 'redirects to forgot your password page' do
          post '/send_password', params: { user: { email: 'any_email' } }

          expect(response).to redirect_to(root_path)
        end

        it 'shows error message' do
          post '/send_password', params: { user: { email: 'any_email' } }

          expect(flash[:alert]).to eq('Falha ao enviar a senha!')
        end
      end

      context 'and occurs errors' do
        it 'redirects to forgot your password page' do
          customer = FactoryBot.create(:customer)

          allow(Customer).to receive(:find_by_email) { raise StandardError }

          post '/send_password', params: { user: { email: customer.email } }

          expect(response).to redirect_to(root_path)
        end

        it 'shows error message' do
          customer = FactoryBot.create(:customer)

          allow(Customer).to receive(:find_by_email) { raise StandardError }

          post '/send_password', params: { user: { email: customer.email } }

          expect(flash[:alert]).to eq('Falha ao enviar a senha!')
        end
      end
    end

    context 'when user is an employee' do
      context 'and pass valid params' do
        it 'redirects to forgot your password page' do
          employee = FactoryBot.create(:employee, :admin)

          allow(Notifications::User)
            .to receive_message_chain(:forgot_your_password, :deliver_now!) { true }

          post '/send_password', params: { user: { email: employee.email } }

          expect(response).to redirect_to(gestao_esqueceu_sua_senha_path)
        end

        it 'shows success message' do
          employee = FactoryBot.create(:employee, :admin)

          allow(Notifications::User)
            .to receive_message_chain(:forgot_your_password, :deliver_now!) { true }

          post '/send_password', params: { user: { email: employee.email } }

          expect(flash[:notice]).to eq('Senha enviada com sucesso!')
        end
      end

      context 'and pass user is not found' do
        it 'redirects to forgot your password page' do
          post '/send_password', params: { user: { email: 'any_email' } }

          expect(response).to redirect_to(root_path)
        end

        it 'shows error message' do
          post '/send_password', params: { user: { email: 'any_email' } }

          expect(flash[:alert]).to eq('Falha ao enviar a senha!')
        end
      end

      context 'and occurs errors' do
        it 'redirects to forgot your password page' do
          employee = FactoryBot.create(:employee, :admin)

          allow(Employee).to receive(:find_by_email) { raise StandardError }

          post '/send_password', params: { user: { email: employee.email } }

          expect(response).to redirect_to(root_path)
        end

        it 'shows error message' do
          employee = FactoryBot.create(:employee)

          allow(Employee).to receive(:find_by_email) { raise StandardError }

          post '/send_password', params: { user: { email: employee.email } }

          expect(flash[:alert]).to eq('Falha ao enviar a senha!')
        end
      end
    end
  end

  describe '#login' do
    it 'renders forgot your password page' do
      get '/cliente/esqueceu_sua_senha'

      expect(response).to render_template(:forgot_your_password)
    end

    it 'renders forgot your password page' do
      get '/gestao/esqueceu_sua_senha'

      expect(response).to render_template(:forgot_your_password)
    end
  end

  describe '#login' do
    it 'renders login page' do
      get '/cliente/login'

      expect(response).to render_template(:login)
    end

    it 'renders login page' do
      get '/gestao/login'

      expect(response).to render_template(:login)
    end
  end

  describe '#index' do
    it 'renders index page' do
      get '/'

      expect(response).to render_template(:index)
    end
  end

  describe '#change_password' do
    it 'renders change password page' do
      get '/cliente/dashboard/trocar_senha'

      expect(response).to render_template(:change_password)
    end

    it 'renders change password page' do
      get '/gestao/dashboard/trocar_senha'

      expect(response).to render_template(:change_password)
    end
  end

  describe '#check_credentials' do
    context 'when customer is active' do
      it 'redirects to customer dashboard page' do
        status = FactoryBot.create(:status, name: 'ativo')
        customer = FactoryBot.create(:customer, status: status)
        post '/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(response).to redirect_to(customer_panel_dashboard_index_path)
      end

      it 'creates customer token' do
        status = FactoryBot.create(:status, name: 'ativo')
        customer = FactoryBot.create(:customer, status: status)

        post '/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        result = session[:customer_token]

        expect(result).to be_present
      end
    end

    context 'when customer is not found' do
      it 'redirects to customer login page' do
        post '/check_credentials',
             params: { customer: { email: 'any email', password: 'any password' } }

        expect(response).to redirect_to(customer_panel_login_path)
      end

      it 'shows error message' do
        post '/check_credentials',
             params: { customer: { email: 'any email', password: 'any password' } }

        expect(flash[:alert]).to eq('Email e/ou senha inválidos!')
      end
    end

    context 'when customer isn\'t authorized' do
      it 'redirects to customer login page' do
        status = FactoryBot.create(:status, name: 'desativado')
        customer = FactoryBot.create(:customer, status: status)

        post '/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(response).to redirect_to(customer_panel_login_path)
      end

      it 'shows error message' do
        status = FactoryBot.create(:status, name: 'desativado')
        customer = FactoryBot.create(:customer, status: status)

        post '/check_credentials',
             params: { customer: { email: customer.email, password: customer.password } }

        expect(flash[:alert]).to eq(
          'Seu status atual não lhe permite o acesso. Por favor, contate-nos!'
        )
      end
    end
  end
end
