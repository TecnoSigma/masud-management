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
      get '/gestao/admin/dashboard/funcionarios'

      expect(response).to render_template(:list)
    end
  end

  describe '#new' do
    it 'renders customers page' do
      get '/gestao/admin/dashboard/funcionario/novo'

      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    context 'when employee is an Administrator' do
      context 'and when pass valid params' do
        it 'creates a new employee' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'administrator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'administrator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'administrator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:notice]).to eq("Funcionário #{employee_name} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new employee' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_nil
        end

        it 'redirects to new employee page' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionario_novo_path)
        end

        it 'shows error message' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :admin,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:alert]).to eq('Erro ao criar novo funcionário!')
        end
      end
    end

    context 'when employee is an Agent' do
      context 'and when pass valid params' do
        it 'creates a new employee' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'agent')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'agent')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'agent')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:notice]).to eq("Funcionário #{employee_name} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new employee' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_nil
        end

        it 'redirects to new employee page' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionario_novo_path)
        end

        it 'shows error message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :agent,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:alert]).to eq('Erro ao criar novo funcionário!')
        end
      end
    end

    context 'when employee is an Approver' do
      context 'and when pass valid params' do
        it 'creates a new employee' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'approver')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'approver')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'approver')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:notice]).to eq("Funcionário #{employee_name} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new employee' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_nil
        end

        it 'redirects to new employee page' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionario_novo_path)
        end

        it 'shows error message' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :approver,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:alert]).to eq('Erro ao criar novo funcionário!')
        end
      end
    end

    context 'when employee is a Lecturer' do
      context 'and when pass valid params' do
        it 'creates a new employee' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'lecturer')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'lecturer')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'lecturer')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:notice]).to eq("Funcionário #{employee_name} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new employee' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_nil
        end

        it 'redirects to new employee page' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionario_novo_path)
        end

        it 'shows error message' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :lecturer,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:alert]).to eq('Erro ao criar novo funcionário!')
        end
      end
    end

    context 'when employee is an Operator' do
      context 'and when pass valid params' do
        it 'creates a new employee' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'operator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_present
        end

        it 'redirects to employees list page' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'operator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
        end

        it 'shows success message' do
          status = FactoryBot.create(:status, name: 'ativo')
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: status.name)

          employee_params.merge!('profile' => 'operator')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:notice]).to eq("Funcionário #{employee_name} criado com sucesso!")
        end
      end

      context 'and when pass invalid params' do
        it 'no creates a new employee' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          result = Employee.find_by_name(employee_name)

          expect(result).to be_nil
        end

        it 'redirects to new employee page' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionario_novo_path)
        end

        it 'shows error message' do
          employee_name = 'João da Silva'
          employee_params = FactoryBot.attributes_for(:employee,
                                                      :operator,
                                                      name: employee_name,
                                                      status: '')

          post '/gestao/admin/dashboard/funcionario/create', params: { employee: employee_params }

          expect(flash[:alert]).to eq('Erro ao criar novo funcionário!')
        end
      end
    end
  end

  describe '#edit' do
    context 'when pass valid params' do
      it 'renders edit page' do
        employee = FactoryBot.create(:employee, :admin)

        get "/gestao/admin/dashboard/funcionario/#{employee.id}/editar"

        expect(response).to render_template(:edit)
      end
    end

    context 'when employee is not found' do
      it 'redirects to employees list page' do
        get '/gestao/admin/dashboard/funcionario/invalid_order_number/editar'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/funcionario/invalid_order_number/editar'

        expect(flash[:alert]).to eq('Funcionário não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to customers list page' do
        employee = FactoryBot.create(:employee, :admin)

        allow(Employee).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/funcionario/#{employee.id}/editar"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
      end

      it 'shows error message' do
        employee = FactoryBot.create(:employee, :admin)

        allow(Employee).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/funcionario/#{employee.id}/editar"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end

  describe '#show' do
    context 'when pass valid params' do
      it 'renders show page' do
        employee = FactoryBot.create(:employee, type: 'Operator')

        get "/gestao/admin/dashboard/funcionario/#{employee.id}"

        expect(response).to render_template(:show)
      end
    end

    context 'when employee is not found' do
      it 'redirects to employees list page' do
        get '/gestao/admin/dashboard/funcionario/invalid_order_number'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
      end

      it 'shows error message' do
        get '/gestao/admin/dashboard/funcionario/invalid_order_number'

        expect(flash[:alert]).to eq('Funcionário não encontrado!')
      end
    end

    context 'when occurs errors' do
      it 'redirects to customers list page' do
        employee = FactoryBot.create(:employee)

        allow(Employee).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/funcionario/#{employee.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
      end

      it 'shows error message' do
        employee = FactoryBot.create(:employee)

        allow(Employee).to receive(:find) { raise StandardError }

        get "/gestao/admin/dashboard/funcionario/#{employee.id}"

        expect(flash[:alert]).to eq('Falha ao procurar dados!')
      end
    end
  end

  describe '#update' do
    context 'when profile is updated' do
      it 'updates employee profile' do
        new_profile = 'Lecturer'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { profile: new_profile } }

        result1 = Administrator.find_by_id(employee.id)
        result2 = Lecturer.find_by_id(employee.id)

        expect(result1).to be_nil
        expect(result2).to be_present
      end

      it 'shows success message' do
        new_profile = 'Lecturer'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { profile: new_profile } }

        expect(flash[:notice]).to eq('Dados do funcionário atualizados com sucesso!')
      end

      it 'redirects to employee page' do
        new_profile = 'Lecturer'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { profile: new_profile } }

        expect(response).to redirect_to(
          employee_panel_administrator_dashboard_employee_show_path(employee.id)
        )
      end
    end

    context 'when pass valid params' do
      it 'updates customer data' do
        new_email = 'aninha@acme.com.br'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        result = Administrator.find(employee.id).email

        expect(result).to eq(new_email)
      end

      it 'shows success message' do
        new_email = 'aninha@acme.com.br'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        expect(flash[:notice]).to eq('Dados do funcionário atualizados com sucesso!')
      end

      it 'redirects to employee page' do
        new_email = 'aninha@acme.com.br'
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        expect(response).to redirect_to(
          employee_panel_administrator_dashboard_employee_show_path(employee.id)
        )
      end
    end

    context 'when pass invalid params' do
      it 'no updates customer data' do
        new_email = ''
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        result = Administrator.find(employee.id).email

        expect(result).not_to eq(new_email)
      end

      it 'shows errors message' do
        new_email = ''
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        expect(flash[:alert]).to eq('Falha ao atualizar dados!')
      end

      it 'redirects to customer page' do
        new_email = ''
        employee = FactoryBot.create(:employee, :admin)

        patch "/gestao/admin/dashboard/funcionario/update/#{employee.id}",
              params: { employee: { email: new_email } }

        expect(response).to redirect_to(employee_panel_administrator_dashboard_funcionarios_path)
      end
    end
  end

  describe '#remove' do
    context 'when pass valid params' do
      xit 'remove logically a customer' do
        FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        result = Customer.find(customer.id).deleted_at

        expect(result).to be_present
      end

      xit 'changes status to \'deletado\'' do
        activated_status = FactoryBot.create(:status, name: 'ativo')
        deleted_status = FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil, status: activated_status)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        result = Customer.find(customer.id).status

        expect(result).to eq(deleted_status)
      end

      xit 'shows success message' do
        FactoryBot.create(:status, name: 'deletado')
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        expect(flash[:notice]).to eq("Cliente #{customer.company} removido com sucesso!")
      end

      xit 'redirects to customer page' do
        customer = FactoryBot.create(:customer, deleted_at: nil)

        delete "/gestao/admin/dashboard/cliente/remove/#{customer.id}"

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end
    end

    context 'when customer isn\'t found' do
      xit 'no removes customer' do
        customer = FactoryBot.create(:customer)

        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        result = Customer.find(customer.id).deleted_at

        expect(result).to be_nil
      end

      xit 'shows errors message' do
        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        expect(flash[:alert]).to eq('Cliente não encontrado!')
      end

      xit 'redirects to customer page' do
        delete '/gestao/admin/dashboard/cliente/remove/invalid_id'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_clientes_path)
      end
    end
  end
end
