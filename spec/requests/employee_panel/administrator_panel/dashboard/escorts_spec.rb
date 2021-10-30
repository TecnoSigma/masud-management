# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Escorts', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#index' do
    context 'renders escorts page' do
      it 'when pass scheduled status' do
        get '/gestao/admin/dashboard/escoltas/scheduled'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass refused status' do
        get '/gestao/admin/dashboard/escoltas/refused'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass blocked status' do
        get '/gestao/admin/dashboard/escoltas/blocked'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass confirmed status' do
        get '/gestao/admin/dashboard/escoltas/confirmed'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass cancelled_by_customer status' do
        get '/gestao/admin/dashboard/escoltas/cancelled_by_customer'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass invalid status' do
        get '/gestao/admin/dashboard/escoltas/invalid_status'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end
    end
  end

  describe '#unblock' do
    context 'when pass valid params' do
      it 'updates order status to \'agendado\'' do
        scheduled_status = FactoryBot.create(:status, name: 'agendado')
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer)

        patch "/gestao/admin/dashboard/escolta/unblock/#{escort.order_number}"

        result = Order.find_by_order_number(escort.order_number).status.name

        expect(result).to eq(scheduled_status.name)
      end

      it 'nullify reason' do
        FactoryBot.create(:status, name: 'agendado')
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer, reason: 'any reason')

        patch "/gestao/admin/dashboard/escolta/unblock/#{escort.order_number}"

        result = Order.find_by_order_number(escort.order_number).reason

        expect(result).to be_nil
      end

      it 'shows success message' do
        FactoryBot.create(:status, name: 'agendado')
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer)

        patch "/gestao/admin/dashboard/escolta/unblock/#{escort.order_number}"

        expect(flash[:notice])
          .to eq("Desbloqueio do pedido #{escort.order_number} executado com sucesso!")
      end

      it 'redirects to blocked escorts page' do
        FactoryBot.create(:status, name: 'agendado')
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer)

        patch "/gestao/admin/dashboard/escolta/unblock/#{escort.order_number}"

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/blocked')
      end
    end

    context 'when pass invalid params' do
      it 'no updates order status to \'agendado\'' do
        scheduled_status = FactoryBot.create(:status, name: 'agendado')
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer)

        patch '/gestao/admin/dashboard/escolta/unblock/invalid_order_number'

        result = Order.find_by_order_number(escort.order_number).status.name

        expect(result).not_to eq(scheduled_status.name)
      end

      it 'no nullify reason' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :blocked, customer: customer, reason: 'any reason')

        patch '/gestao/admin/dashboard/escolta/unblock/invalid_order_number'

        result = Order.find_by_order_number(escort.order_number).reason

        expect(result).to be_present
      end

      it 'shows error message' do
        invalid_order_number = '1234'

        patch "/gestao/admin/dashboard/escolta/unblock/#{invalid_order_number}"

        expect(flash[:alert]).to eq("Falha ao desbloquear pedido #{invalid_order_number}!")
      end

      it 'redirects to blocked escorts page' do
        patch '/gestao/admin/dashboard/escolta/unblock/invalid_order_number'

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/blocked')
      end
    end
  end

  describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :scheduled, customer: customer)

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(response).to render_template(:show)
      end
    end

    context 'when escort is not found' do
      it 'redirects to escorts page' do
        get '/gestao/admin/dashboard/escolta/invalid_order_number'

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/scheduled')
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/escolta/invalid_order_number'

        expect(flash[:alert]).to eq('Escolta não encontrada!')
      end
    end

    context 'when order isn\'t an escort' do
      it 'redirects to escorts page' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, type: nil, customer: customer)

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/scheduled')
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, type: nil, customer: customer)

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(flash[:alert]).to eq('Escolta não encontrada!')
      end
    end
  end
end
