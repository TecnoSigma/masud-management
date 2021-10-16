# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Arsenals::Munitions', type: :request do
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

  describe '#new' do
    it 'renders new munition type page' do
      get '/gestao/admin/dashboard/arsenais/municao/novo'

      expect(response).to render_template(:new)
    end
  end

  describe '#edit' do
    context 'when pass valid params' do
      it 'renders edit page' do
        gun = FactoryBot.create(:arsenal, :munition)

        get "/gestao/admin/dashboard/arsenais/municao/#{gun.id}/editar"

        expect(response).to render_template(:edit)
      end
    end

    context 'when munition is not found' do
      it 'redirects to munitions list page' do
        get '/gestao/admin/dashboard/arsenais/municao/invalid_order_number/editar'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/arsenais/municao/invalid_order_number/editar'

        expect(flash[:alert]).to eq('Munição não encontrada!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to tackles list page' do
        munition = FactoryBot.create(:arsenal, :munition)

        allow(Munition).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/arsenais/municao/#{munition.id}/editar"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end

      it 'shows error message' do
        munition = FactoryBot.create(:arsenal, :munition)

        allow(Munition).to receive(:find) { raise StandardError }

        get get "/gestao/admin/dashboard/arsenais/municao/#{munition.id}/editar"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
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

  describe '#update' do
    context 'when pass valid params' do
      it 'updates munition data' do
        new_quantity = 500
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        result = Munition.find(munition.id).quantity

        expect(result).to eq(new_quantity)
      end

      it 'shows success message' do
        new_quantity = 500
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        expect(flash[:notice]).to eq('Quantidade de munição atualizada com sucesso!')
      end

      it 'redirects to munution page' do
        new_quantity = 500
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end
    end

    context 'when pass invalid params' do
      it 'no updates gun data' do
        new_quantity = -1
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        result = Munition.find(munition.id).quantity

        expect(result).not_to eq(new_quantity)
      end

      it 'shows errors message' do
        new_quantity = -1
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        expect(flash[:alert]).to eq('Falha ao atualizar dados!')
      end

      it 'redirects to customer page' do
        new_quantity = -1
        munition = FactoryBot.create(:arsenal, :munition)

        patch "/gestao/admin/dashboard/arsenais/municao/update/#{munition.id}",
              params: { munition: { quantity: new_quantity } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end
    end
  end

  describe '#remove' do
    context 'when pass valid params' do
      it 'remove a munition' do
        munition = FactoryBot.create(:arsenal, :munition)

        delete "/gestao/admin/dashboard/arsenais/municao/remove/#{munition.id}"

        result = Munition.find_by_id(munition.id)

        expect(result).to be_nil
      end

      it 'shows success message' do
        munition = FactoryBot.create(:arsenal, :munition)

        delete "/gestao/admin/dashboard/arsenais/municao/remove/#{munition.id}"

        expect(flash[:notice]).to eq("Munição #{munition.kind} removida com sucesso!")
      end

      it 'redirects to guns page' do
        munition = FactoryBot.create(:arsenal, :munition)

        delete "/gestao/admin/dashboard/arsenais/municao/remove/#{munition.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end
    end

    context 'when munition isn\'t found' do
      it 'shows errors message' do
        delete '/gestao/admin/dashboard/arsenais/municao/remove/invalid_id'

        expect(flash[:alert]).to eq('Munição não encontrada!')
      end

      it 'redirects to guns page' do
        delete '/gestao/admin/dashboard/arsenais/municao/remove/invalid_id'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_municoes_path)
      end
    end
  end
end
