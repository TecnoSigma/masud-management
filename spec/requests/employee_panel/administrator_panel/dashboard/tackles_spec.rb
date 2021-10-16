# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AdministratorPanel::Dashboard::Employees', type: :request do
  before(:each) do
    allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
    allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }
  end

  describe '#list' do
    it 'renders tackles page' do
      get '/gestao/admin/dashboard/equipamentos'

      expect(response).to render_template(:list)
    end
  end

  describe '#new' do
    it 'renders tackles page' do
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

  describe '#edit' do
    context 'when pass valid params' do
      it 'renders edit page' do
        tackle = FactoryBot.create(:tackle, :radio)

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}/editar"

        expect(response).to render_template(:edit)
      end
    end

    context 'when tackle is not found' do
      it 'redirects to tackles list page' do
        get '/gestao/admin/dashboard/equipamento/invalid_order_number/editar'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/equipamento/invalid_order_number/editar'

        expect(flash[:alert]).to eq('Equipamento não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to tackles list page' do
        tackle = FactoryBot.create(:tackle, :radio)

        allow(Tackle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}/editar"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end

      it 'shows error message' do
        tackle = FactoryBot.create(:tackle)

        allow(Tackle).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/equipamento/#{tackle.id}/editar"

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

  describe '#update' do
    context 'when type is updated' do
      it 'updates tackle profile' do
        new_type = 'Waistcoat'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { type: new_type } }

        result1 = Radio.find_by_id(tackle.id)
        result2 = Waistcoat.find_by_id(tackle.id)

        expect(result1).to be_nil
        expect(result2).to be_present
      end

      it 'shows success message' do
        new_type = 'Waistcoat'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { type: new_type } }

        expect(flash[:notice]).to eq('Dados do equipamento atualizados com sucesso!')
      end

      it 'redirects to employee page' do
        new_type = 'Waistcoat'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { type: new_type } }

        expect(response).to redirect_to(
          employee_panel_administrator_dashboard_tackle_show_path(tackle.id)
        )
      end
    end

    context 'when pass valid params' do
      it 'updates tackle data' do
        new_serial_number = 'abcd1234'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        result = Radio.find(tackle.id).serial_number

        expect(result).to eq(new_serial_number)
      end

      it 'shows success message' do
        new_serial_number = 'abcd1234'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        expect(flash[:notice]).to eq('Dados do equipamento atualizados com sucesso!')
      end

      it 'redirects to employee page' do
        new_serial_number = 'abcd1234'
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_tackle_show_path(tackle.id))
      end
    end

    context 'when pass invalid params' do
      it 'no updates tackle data' do
        new_serial_number = ''
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        result = Radio.find(tackle.id).serial_number

        expect(result).not_to eq(new_serial_number)
      end

      it 'shows errors message' do
        new_serial_number = ''
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        expect(flash[:alert]).to eq('Falha ao atualizar dados!')
      end

      it 'redirects to tackle page' do
        new_serial_number = ''
        tackle = FactoryBot.create(:tackle, :radio)

        patch "/gestao/admin/dashboard/equipamento/update/#{tackle.id}",
              params: { tackle: { serial_number: new_serial_number } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end
    end
  end

  describe '#remove' do
    context 'when pass valid params' do
      it 'remove a tackle' do
        tackle = FactoryBot.create(:tackle, :radio)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        result = Tackle.find_by_id(tackle.id)

        expect(result).to be_nil
      end

      it 'shows success message' do
        tackle = FactoryBot.create(:tackle, :radio)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        expect(flash[:notice]).to eq("Rádio #{tackle.serial_number} removido com sucesso!")
      end

      it 'redirects to tackle page' do
        tackle = FactoryBot.create(:tackle, :radio)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end
    end

    context 'when tackle isn\'t found' do
      it 'shows errors message' do
        delete '/gestao/admin/dashboard/equipamento/remove/invalid_id'

        expect(flash[:alert]).to eq('Equipamento não encontrado!')
      end

      it 'redirects to tackle page' do
        delete '/gestao/admin/dashboard/equipamento/remove/invalid_id'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end
    end

    context 'when tackle is in mission' do
      it 'no deletes tackle' do
        employee = FactoryBot.create(:employee, :agent)
        tackle = FactoryBot.create(:tackle, :radio, employee_id: employee.id)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        result = Tackle.find(tackle.id)

        expect(result).to be_present
      end

      it 'shows errors message' do
        employee = FactoryBot.create(:employee, :agent)
        tackle = FactoryBot.create(:tackle, :radio, employee_id: employee.id)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        expect(flash[:alert]).to eq('Equipamento em missão não pode ser removido!')
      end

      it 'redirects to tackle page' do
        employee = FactoryBot.create(:employee, :agent)
        tackle = FactoryBot.create(:tackle, :radio, employee_id: employee.id)

        delete "/gestao/admin/dashboard/equipamento/remove/#{tackle.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_equipamentos_path)
      end
    end
  end
end
