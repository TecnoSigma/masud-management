# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Employees', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#list' do
    it 'renders customers page' do
      get '/gestao/admin/dashboard/equipamentos'

      expect(response).to render_template(:list)
    end
  end

    describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        tackle = FactoryBot.create(:tackle, :radio)

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}"

        expect(response).to render_template(:show)
      end
    end

    context 'when tackle is not found' do
      it 'redirects to tackles list page' do
        get '/gestao/admin/dashboard/equipamento/invalid_order_number'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/equipamento/invalid_order_number'

        expect(flash[:alert]).to eq('Equipamento não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to customers list page' do
        tackle = FactoryBot.create(:tackle, :radio)

        allow(Tackle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end

      it 'shows error message' do
        tackle = FactoryBot.create(:tackle)

        allow(Tackle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end
end
