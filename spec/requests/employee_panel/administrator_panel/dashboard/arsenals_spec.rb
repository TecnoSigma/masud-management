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

  describe '#new_gun' do
    it 'renders employees page' do
      get '/gestao/admin/dashboard/arsenais/arma/novo'

      expect(response).to render_template(:new_gun)
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

  describe '#create' do
    context 'when pass valid params' do
      it 'creates a new gun' do
        status = FactoryBot.create(:status, name: 'ativo')
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: status.name)

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        result = Gun.find_by_sinarm(sinarm)

        expect(result).to be_present
      end

      it 'redirects to guns list page' do
        status = FactoryBot.create(:status, name: 'ativo')
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: status.name)

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_armas_path)
      end

      it 'shows success message' do
        status = FactoryBot.create(:status, name: 'ativo')
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: status.name)

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        expect(flash[:notice]).to eq("Arma #{sinarm} criada com sucesso!")
      end
    end

    context 'when pass invalid params' do
      it 'no creates a new gun' do
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: '')

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        result = Gun.find_by_sinarm(sinarm)

        expect(result).to be_nil
      end

      it 'redirects to new tackle page' do
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: '')

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_arsenais_arma_novo_path)
      end

      it 'shows error message' do
        situation = FactoryBot.create(:status, name: 'regular')
        sinarm = '123'
        gun_params = FactoryBot.attributes_for(:arsenal,
                                               :gun,
                                               sinarm: sinarm,
                                               situation: situation.name,
                                               status: '')

        post '/gestao/admin/dashboard/arsenais/arma/create', params: { gun: gun_params }

        expect(flash[:alert]).to eq('Erro ao criar nova arma!')
      end
    end
  end
end
