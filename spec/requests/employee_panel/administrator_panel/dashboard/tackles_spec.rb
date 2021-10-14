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

  describe '#new' do
    it 'renders customers page' do
      get '/gestao/admin/dashboard/equipamento/novo'

      expect(response).to render_template(:new)
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

  describe '#create' do
    context 'when type is a radio' do
      context 'and when pass valid params' do
        it 'creates a new tackle' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          result = Tackle.find_by_serial_number(serial_number)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(flash[:notice]).to eq("Equipamento #{serial_number} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new tackle' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          result = Tackle.find_by_serial_number(serial_number)

          expect(result).to be_nil
        end

        it 'redirects to new tackle page' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamento_novo_path)
        end

        it 'shows error message' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :radio,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(flash[:alert]).to eq('Erro ao criar novo equipamento!')
        end
      end
    end

    context 'when type is a waistcoat' do
      context 'and when pass valid params' do
        it 'creates a new tackle' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          result = Tackle.find_by_serial_number(serial_number)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: status.name)

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(flash[:notice]).to eq("Equipamento #{serial_number} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new tackle' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          result = Tackle.find_by_serial_number(serial_number)

          expect(result).to be_nil
        end

        it 'redirects to new tackle page' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamento_novo_path)
        end

        it 'shows error message' do
          situation = FactoryBot.create(:status, name: 'regular')
          serial_number = '123'
          tackle_params = FactoryBot.attributes_for(:tackle,
                                                    :waistcoat,
                                                    serial_number: serial_number,
                                                    situation: situation.name,
                                                    status: '')

          post '/gestao/admin/dashboard/equipamento/create', params: { tackle: tackle_params }

          expect(flash[:alert]).to eq('Erro ao criar novo equipamento!')
        end
      end
    end
  end
end
