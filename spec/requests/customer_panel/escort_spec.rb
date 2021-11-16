# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel::Escort', type: :request do
  describe '#cancel' do
    context 'when pass valid params' do
      it 'runs logic deletion' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        FactoryBot.create(:status, name: 'cancelada pelo cliente')

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

      it 'changes status to \'cancelada pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        cancellation_status = FactoryBot.create(:status, name: 'cancelada pelo cliente')

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
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        FactoryBot.create(:status, name: 'cancelada pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
      end

      it 'shows sucess message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        FactoryBot.create(:status, name: 'cancelada pelo cliente')

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
      it 'no changes status to \'cancelada pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

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

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        delete '/cliente/dashboard/escolta/cancel/any_invalid_order_number'

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        delete '/cliente/dashboard/escolta/cancel/any_invalid_order_number'

        expect(flash[:alert]).to eq('Falha ao cancelar agendamento!')
      end
    end

    context 'when occurs error' do
      it 'no changes status to \'cancelada pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

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
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status)

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

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
      it 'no changes status to \'cancelada pelo cliente\'' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   job_horary: (DateTime.now + 10.minutes).strftime('%H:%M'),
                                   job_day: DateTime.now.strftime('%d/%m/%Y'))

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        result = EscortScheduling.find(escort.id).status

        expect(result).to eq(status)
      end

      it 'redirects to escorts list page' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        FactoryBot.create(:status, name: 'cancelada pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   job_horary: (DateTime.now + 10.minutes).strftime('%H:%M'),
                                   job_day: DateTime.now.strftime('%d/%m/%Y'))

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        status = FactoryBot.create(:status, name: 'aguardando confirmação')
        FactoryBot.create(:status, name: 'cancelada pelo cliente')

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

        escort = FactoryBot.create(:order,
                                   :scheduled,
                                   customer: customer,
                                   status: status,
                                   job_horary: (DateTime.now + 10.minutes).strftime('%H:%M'),
                                   job_day: DateTime.now.strftime('%d/%m/%Y'))

        delete "/cliente/dashboard/escolta/cancel/#{escort.order_number}"

        expect(flash[:alert]).to eq('Falha ao cancelar agendamento!')
      end
    end
  end

  describe '#not_finished' do
    it 'renders not finished escorts list page' do
      customer = FactoryBot.create(:customer)
      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/dashboard/escolta/nao_finalizadas'

      expect(response).to render_template(:not_finished)
    end
  end

  describe '#finished' do
    it 'renders finished escorts list page' do
      customer = FactoryBot.create(:customer)
      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/dashboard/escolta/finalizadas'

      expect(response).to render_template(:finished)
    end
  end

  describe '#service_order' do
    it 'renders service order page in PDF format' do
      FactoryBot.create(:status, name: 'iniciada')
      FactoryBot.create(:status, name: 'finalizada')

      customer = FactoryBot.create(:customer)
      employee = FactoryBot.create(:employee, :agent, last_mission: nil)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order,
                                :confirmed,
                                customer: customer)

      escort_service = EscortService.find(order.id)

      mission = FactoryBot.create(:mission,
                                  team: team,
                                  escort_service: escort_service,
                                  observation: nil)

      FactoryBot.create(:mission_history, mission: mission)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
      allow(MissionsHistoryPresenter).to receive(:fullnames_with_document) { '' }

      get "/cliente/dashboard/escolta/service_order/#{escort_service.order_number}.pdf"

      expect(response).to render_template(:order_service)
    end
  end

  describe '#pre_alert' do
    it 'renders pre alert page in PDF format' do
      customer = FactoryBot.create(:customer)

      FactoryBot.create(:status, name: 'iniciada')
      employee = FactoryBot.create(:employee, :agent)
      agent = Agent.find(employee.id)

      team = FactoryBot.create(:team)
      team.agents << agent
      team.save

      order = FactoryBot.create(:order, :confirmed, customer: customer)
      escort_service = EscortService.find(order.id)

      FactoryBot.create(:mission, team: team, escort_service: escort_service)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get "/cliente/dashboard/escolta/pre_alert/#{escort_service.order_number}.pdf"

      expect(response).to render_template(:pre_alert)
    end
  end

  describe '#create' do
    context 'when pass valid params' do
      it 'creates a new escort' do
        active_status = FactoryBot.create(:status, name: 'ativo')
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Notifications::Customers::Orders::Escort)
          .to receive_message_chain(:scheduling, :deliver_now!) { true }

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
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Notifications::Customers::Orders::Escort)
          .to receive_message_chain(:scheduling, :deliver_now!) { true }

        escort_params = FactoryBot.attributes_for(:order,
                                                  :scheduled,
                                                  customer: customer,
                                                  status: status)

        post '/cliente/dashboard/escolta/create', params: { escort: escort_params }

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
      end

      it 'shows success message' do
        active_status = FactoryBot.create(:status, name: 'ativo')
        status = FactoryBot.create(:status, name: 'aguardando confirmação')

        customer = FactoryBot.create(:customer, status: active_status)

        allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
        allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
        allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }
        allow(Notifications::Customers::Orders::Escort)
          .to receive_message_chain(:scheduling, :deliver_now!) { true }

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

        expect(response).to redirect_to(customer_panel_dashboard_escolta_nao_finalizadas_path)
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
