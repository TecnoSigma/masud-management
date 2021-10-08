# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Escorts', type: :request do
  describe '#index' do
    context 'renders escorts page' do
      it 'when pass scheduled status' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escoltas/scheduled'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass refused status' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escoltas/refused'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass confirmed status' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escoltas/confirmed'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass cancelled_by_customer status' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escoltas/cancelled_by_customer'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end

      it 'when pass invalid status' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escoltas/invalid_status'

        expect(response)
          .to render_template('employee_panel/administrator_panel/dashboard/escorts/escorts')
      end
    end
  end

  describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :scheduled, customer: customer)

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(response).to render_template(:show)
      end
    end

    context 'when escort is not found' do
      it 'redirects to escorts page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escolta/invalid_order_number'

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/scheduled')
      end

      it 'shows error message' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/admin/dashboard/escolta/invalid_order_number'

        expect(flash[:alert]).to eq('Escolta não encontrada!')
      end
    end

    context 'when order isn\'t an escort' do
      it 'redirects to escorts page' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, type: nil, customer: customer)

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/scheduled')
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, type: nil, customer: customer)

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(flash[:alert]).to eq('Escolta não encontrada!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to escorts page' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :scheduled, customer: customer)

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        allow(Order).to receive(:find_by_order_number) { raise StandardError }

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(response).to redirect_to('/gestao/admin/dashboard/escoltas/scheduled')
      end

      it 'shows error message' do
        customer = FactoryBot.create(:customer)
        escort = FactoryBot.create(:order, :scheduled, customer: customer)

        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        allow(Order).to receive(:find_by_order_number) { raise StandardError }

        get "/gestao/admin/dashboard/escolta/#{escort.order_number}"

        expect(flash[:alert]).to eq('Falha ao procurar escoltas!')
      end
    end
  end
end
