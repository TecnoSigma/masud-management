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
      get '/gestao/admin/dashboard/viaturas'

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

    describe '#create' do
    context 'when pass valid params' do
      it 'creates a new vehicle' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        result = Vehicle.find_by_license_plate(license_plate)

        expect(result).to be_present
      end

      it 'redirects to vehicles list page' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end

      it 'shows success message' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        expect(flash[:notice]).to eq("Viatura #{license_plate} criada com sucesso!")
      end
    end

    context 'when pass invalid params' do
      it 'no creates a new gun' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   color: '',
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        result = Vehicle.find_by_license_plate(license_plate)

        expect(result).to be_nil
      end

      it 'redirects to new vehicle page' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   color: '',
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viatura_novo_path)
      end

      it 'shows error message' do
        status = FactoryBot.create(:status, name: 'ativo')
        license_plate = 'ABC-1234'
        vehicle_params = FactoryBot.attributes_for(:vehicle,
                                                   license_plate: license_plate,
                                                   color: '',
                                                   status: status.name)

        post '/gestao/admin/dashboard/viatura/create', params: { vehicle: vehicle_params }

        expect(flash[:alert]).to eq('Erro ao criar nova viatura!')
      end
    end
  end

  describe '#edit' do
    context 'when pass valid params' do
      it 'renders edit page' do
        vehicle = FactoryBot.create(:vehicle)

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}/editar"

        expect(response).to render_template(:edit)
      end
    end

    context 'when gun is not found' do
      it 'redirects to vehicles list page' do
        get '/gestao/admin/dashboard/viatura/invalid_order_number/editar'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/viatura/invalid_order_number/editar'

        expect(flash[:alert]).to eq('Viatura não encontrada!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to vehicle list page' do
        vehicle = FactoryBot.create(:vehicle)

        allow(Vehicle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}/editar"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end

      it 'shows error message' do
        vehicle = FactoryBot.create(:vehicle)

        allow(Vehicle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/viatura/#{vehicle.id}/editar"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end

  describe '#update' do
    context 'when pass valid params' do
      it 'updates vehicle data' do
        new_color = 'Branco'
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        result = Vehicle.find(vehicle.id).color

        expect(result).to eq(new_color)
      end

      it 'shows success message' do
        new_color = 'Branco'
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        expect(flash[:notice]).to eq('Dados da viatura atualizados com sucesso!')
      end

      it 'redirects to vehicle page' do
        new_color = 'Branco'
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_vehicle_show_path(vehicle.id))
      end
    end

    context 'when pass invalid params' do
      it 'no updates gun data' do
        new_color = ''
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        result = Vehicle.find(vehicle.id).color

        expect(result).not_to eq(new_color)
      end

      it 'shows errors message' do
        new_color = ''
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        expect(flash[:alert]).to eq('Falha ao atualizar dados!')
      end

      it 'redirects to customer page' do
        new_color = ''
        vehicle = FactoryBot.create(:vehicle)

        patch "/gestao/admin/dashboard/viatura/update/#{vehicle.id}",
              params: { vehicle: { color: new_color } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end
    end
  end

  describe '#remove' do
    context 'when pass valid params' do
      it 'remove a vehicle' do
        vehicle = FactoryBot.create(:vehicle)

        delete "/gestao/admin/dashboard/viatura/remove/#{vehicle.id}"

        result = Vehicle.find_by_id(vehicle.id)

        expect(result).to be_nil
      end

      it 'shows success message' do
        vehicle = FactoryBot.create(:vehicle)

        delete "/gestao/admin/dashboard/viatura/remove/#{vehicle.id}"

        expect(flash[:notice]).to eq("Viatura #{vehicle.license_plate} removida com sucesso!")
      end

      it 'redirects to vehicles page' do
        vehicle = FactoryBot.create(:vehicle)

        delete "/gestao/admin/dashboard/viatura/remove/#{vehicle.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end
    end

    context 'when gun isn\'t found' do
      it 'shows errors message' do
        delete '/gestao/admin/dashboard/viatura/remove/invalid_id'

        expect(flash[:alert]).to eq('Viatura não encontrada!')
      end

      it 'redirects to vehicles page' do
        delete '/gestao/admin/dashboard/viatura/remove/invalid_id'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_viaturas_path)
      end
    end
  end
end
