# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Arsenals', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#guns_list' do
    it 'renders employees page' do
      get '/gestao/admin/dashboard/arsenais/armas'

      expect(response).to render_template(:guns_list)
    end
  end

  describe '#show_gun' do
    context 'when pass valid params' do
      it 'renders show page' do
        gun = FactoryBot.create(:arsenal, :gun)

        get "/gestao/admin/dashboard/arsenais/arms/#{gun.id}"

        expect(response).to render_template(:show_gun)
      end
    end

    context 'when gun is not found' do
      it 'redirects to guns list page' do
        get '/gestao/admin/dashboard/arsenais/arma/invalid_order_number'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_armas_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/arsenais/arma/invalid_order_number'

        expect(flash[:alert]).to eq('Arma não encontrada!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to tackles list page' do
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
