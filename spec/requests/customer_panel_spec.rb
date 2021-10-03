# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/cliente/logout'

      expect(response).to redirect_to(customer_panel_login_path)
    end
  end

  describe '#main' do
    it 'redirects to main page when exists customer token and have authorization' do
      allow_any_instance_of(CustomerPanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(CustomerPanelController).to receive(:authorized?) { true }

      get '/cliente/dashboard/index'

      expect(response).to render_template(:index)
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/cliente/login'

      expect(response).to render_template(:login)
    end
  end

  describe '#cities' do
    it 'returns cities list in JSON format' do
      state = FactoryBot.create(:state)
      city = FactoryBot.create(:city, state: state)

      customer = FactoryBot.create(:customer)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/cities', params: { state_name: state.name }

      expect(response.body).to eq("{\"cities\":[\"#{city.name}\"]}")
      expect(response).to have_http_status(200)
    end

    it 'returns empty list wehn occurs errors' do
      customer = FactoryBot.create(:customer)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/cities'

      expect(response.body).to eq('{"cities":[]}')
      expect(response).to have_http_status(500)
    end
  end

  describe '#update_password' do
    context 'when pass good password' do
      context 'and user is a customer' do
        it 'updates password' do
          new_password = 'iuwewi3KKJOI443'
          customer = FactoryBot.create(:customer)

          allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
          allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
          allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

          patch '/update_password',
                params: { customer_password: { new_password: new_password,
                                               current_password: customer.password,
                                               email: customer.email } }

          result = Customer.find(customer.id).password

          expect(result).to eq(new_password)
        end

        it 'redirects to dashboard change password page' do
          new_password = 'iuwewi3KKJOI443'
          customer = FactoryBot.create(:customer)

          allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
          allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
          allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

          patch '/update_password',
                params: { customer_password: { new_password: new_password,
                                               current_password: customer.password,
                                               email: customer.email } }

          expect(response).to redirect_to(cliente_dashboard_trocar_senha_path)
        end

        it 'shows success message' do
          new_password = 'iuwewi3KKJOI443'
          customer = FactoryBot.create(:customer)

          allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
          allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
          allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

          patch '/update_password',
                params: { customer_password: { new_password: new_password,
                                               current_password: customer.password,
                                               email: customer.email } }

          expect(flash[:notice]).to eq('Senha alterada com sucesso!')
        end
      end
    end

    context 'when pass weak password' do
      it ' no updates password' do
        new_password = '123456'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }

        result = Customer.find(customer.id).password

        expect(result).not_to eq(new_password)
      end

      it 'redirects to change password page' do
        new_password = '123456'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }

        expect(response).to redirect_to(cliente_dashboard_trocar_senha_path)
      end

      it 'shows error message' do
        new_password = '123456'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }
        expect(flash[:alert]).to eq('A nova senha é muito fraca!... Tente outra!')
      end
    end

    context 'when pass same password' do
      it 'no updates password' do
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: customer.password,
                                             current_password: customer.password,
                                             email: customer.email } }

        result = Customer.find(customer.id).password

        expect(result).to eq(customer.password)
      end

      it 'redirects to change password page' do
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: customer.password,
                                             current_password: customer.password,
                                             email: customer.email } }

        expect(response).to redirect_to(cliente_dashboard_trocar_senha_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        patch '/update_password',
              params: { customer_password: { new_password: customer.password,
                                             current_password: customer.password,
                                             email: customer.email } }

        expect(flash[:alert]).to eq('As senhas utilizadas são iguais!')
      end
    end

    context 'when occurs some errors' do
      it 'no updates password' do
        new_password = 'iuwewi3KKJOI443'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Customer).to receive(:find_by) { raise StandardError }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }

        result = Customer.find(customer.id).password

        expect(result).not_to eq(new_password)
      end

      it 'redirects to change password page' do
        new_password = 'iuwewi3KKJOI443'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Customer).to receive(:find_by) { raise StandardError }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }

        expect(response).to redirect_to(cliente_dashboard_trocar_senha_path)
      end

      it 'shows error message' do
        new_password = 'iuwewi3KKJOI443'
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Customer).to receive(:find_by) { raise StandardError }

        patch '/update_password',
              params: { customer_password: { new_password: new_password,
                                             current_password: customer.password,
                                             email: customer.email } }

        expect(flash[:alert]).to eq('Falha ao alterar a senha!')
      end
    end
  end
end
