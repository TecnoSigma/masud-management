# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Arsenals::Guns', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#list' do
    it 'renders munitions page' do
      get '/gestao/admin/dashboard/arsenais/municoes'

      expect(response).to render_template(:list)
    end
  end

  describe '#list' do
    it 'renders new munition type page' do
      get '/gestao/admin/dashboard/arsenais/municao/novo'

      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when pass valid params' do
      it 'creates a new munition type' do
        caliber_type = '50'
        munition_params = FactoryBot.attributes_for(:arsenal, :munition, kind: caliber_type)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        result = Munition.find_by_kind(caliber_type)

        expect(result).to be_present
      end

      it 'redirects to munitions list page' do
        munition_params = FactoryBot.attributes_for(:arsenal, :munition)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end

      it 'shows success message' do
        caliber_type = '50'
        munition_params = FactoryBot.attributes_for(:arsenal, :munition, kind: caliber_type)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        expect(flash[:notice]).to eq("Munição #{caliber_type} criada com sucesso!")
      end
    end

    context 'when pass invalid params' do
      it 'no creates a new munition' do
        caliber_type = ''
        munition_params = FactoryBot.attributes_for(:arsenal, :munition, kind: caliber_type)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        result = Munition.find_by_kind(caliber_type)

        expect(result).to be_nil
      end

      it 'redirects to new munition page' do
        caliber_type = ''
        munition_params = FactoryBot.attributes_for(:arsenal, :munition, kind: caliber_type)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municao_novo_path)
      end

      it 'shows error message' do
        caliber_type = ''
        munition_params = FactoryBot.attributes_for(:arsenal, :munition, kind: caliber_type)

        post '/gestao/admin/dashboard/arsenais/municao/create',
             params: { munition: munition_params }

        expect(flash[:alert]).to eq('Erro ao criar nova munição!')
      end
    end
  end
end
