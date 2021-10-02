# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel::Escort', type: :request do
  describe '#cancel' do
    context 'when pass valid params' do
      it 'runs logic deletion' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        result = EscortScheduling.find(escort.id).deleted_at

        expect(result).to be_present
      end

      it 'changes status to \'cancelado pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        cancellation_status = FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        result = EscortScheduling.find(escort.id).status

        expect(result).to eq(cancellation_status)
      end

      it 'redirects to escorts list page' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows sucess message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(flash[:notice]).to eq('Agendamento cancelado com sucesso!')
      end
    end

    context 'when pass invalid params' do
      it 'no changes status to \'cancelado pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        cancellation_status = FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete '/cliente/dashboard/escolta/cancel/any_invalid_order_number'

        result = EscortScheduling.find(escort.id).status

        expect(result).to eq(status)
      end

      it 'redirects to escorts list page' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        cancellation_status = FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete '/cliente/dashboard/escolta/cancel/any_invalid_order_number'

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        cancellation_status = FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete '/cliente/dashboard/escolta/cancel/any_invalid_order_number'

        expect(flash[:alert]).to eq('Falha ao cancelar agendamento!')
      end
    end

    context 'when occurs error' do
      it 'no changes status to \'cancelado pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }


        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        result = EscortScheduling.find(escort.id).status

        expect(result).to eq(status)
      end

      it 'redirects to escorts list page' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(flash[:alert]).to eq('Falha ao cancelar agendamento!')
      end
    end

    context 'when escort scheduling isn\'t deletable' do
      it 'no changes status to \'cancelado pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        cancellation_status = FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   created_at: 4.hours.ago)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        result = EscortScheduling.find(escort.id).status

        expect(result).to eq(status)
      end

      it 'redirects to escorts list page' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   created_at: 4.hours.ago)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'agendado')
        FactoryBot.create(:status, name: 'cancelado pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   created_at: 4.hours.ago)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(flash[:alert]).to eq('Falha ao cancelar agendamento!')
      end
    end
  end

  describe '#list' do
    it 'renders escorts list page' do
      customer = FactoryBot.create(:customer)
      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/dashboard/escolta/lista'

      expect(response).to render_template(:list)
    end
  end

  describe '#create' do
    context 'when pass valid params' do
      it 'creates a new escort' do
        active_status = FactoryBot.create(:status, name: 'ativo')
        scheduled_status= FactoryBot.create(:status, name: 'agendado')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  customer: customer,
                                                  status: status)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        result = Escort.last.customer

        expect(result).to eq(customer)
      end

      it 'redirect to escort list' do
        active_status = FactoryBot.create(:status, name: 'ativo')
        scheduled_status = FactoryBot.create(:status, name: 'agendado')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  customer: customer,
                                                  status: status)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows success message' do
        active_status = FactoryBot.create(:status, name: 'ativo')
        scheduled_status = FactoryBot.create(:status, name: 'agendado')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  customer: customer,
                                                  status: status)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        expect(flash[:notice]).to eq('Agendamento criado com sucesso!')
      end
    end

    context 'when pass invalid params' do
      it 'no creates a new escort' do
        active_status = FactoryBot.create(:status, name: 'ativo')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  job_day: nil,
                                                  customer: customer)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        result = Escort.count

        expect(result).to eq(0)
      end

      it 'redirects to escort list' do
        active_status = FactoryBot.create(:status, name: 'ativo')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  job_day: nil,
                                                  customer: customer)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        expect(response).to redirect_to(customer_panel_dashboard_escolta_lista_path)
      end

      it 'shows error message' do
        active_status = FactoryBot.create(:status, name: 'ativo')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  job_day: nil,
                                                  customer: customer)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        expect(flash[:alert]).to eq('Falha ao criar agendamento!')
      end
    end
  end
end
