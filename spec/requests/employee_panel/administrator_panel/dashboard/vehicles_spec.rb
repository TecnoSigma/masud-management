# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Vehicles', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#list' do
    it 'renders vehicles list page' do
      get '/gestao/admin/dashboard/veiculos'

      expect(response).to render_template(:list)
    end
  end

  describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        vehicle = FactoryBot.create(:vehicle)

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}"

        expect(response).to render_template(:show)
      end
    end

    context 'when gun is not found' do
      it 'redirects to guns list page' do
        get '/gestao/admin/dashboard/viatura/invalid_order_number'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/viatura/invalid_order_number'

        expect(flash[:alert]).to eq('Viatura não encontrada!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to vehicles list page' do
        vehicle = FactoryBot.create(:vehicle)

        allow(Vehicle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end

      it 'shows error message' do
        vehicle = FactoryBot.create(:vehicle)

        allow(Vehicle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end
end
