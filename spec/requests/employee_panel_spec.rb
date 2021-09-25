# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/gestao/logout'

      expect(response).to redirect_to(employee_panel_login_path)
    end
  end

  describe '#main' do
    context 'when is administrator profile' do
      it 'redirects to administrator dashboard' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/main'

        expect(response).to redirect_to(employee_panel_administrator_dashboard_path)
      end
    end

    context 'when is agent profile' do
      it 'redirects to agent dashboard' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'agent' }

        get '/gestao/main'

        expect(response).to redirect_to(employee_panel_agent_dashboard_path)
      end
    end

    context 'when is lecturer profile' do
      it 'redirects to lecturer dashboard' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'lecturer' }

        get '/gestao/main'

        expect(response).to redirect_to(employee_panel_lecturer_dashboard_path)
      end
    end

    context 'when is operator profile' do
      it 'redirects to operator dashboard' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        get '/gestao/main'

        expect(response).to redirect_to(employee_panel_operator_dashboard_path)
      end
    end

    context 'when occurs errors' do
      it 'redirects to employee login page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { raise StandardError }

        get '/gestao/main'

        expect(response).to redirect_to(employee_panel_login_path)
      end
    end
  end

  describe '#logout' do
    it 'renders to login page' do
      get '/gestao/logout'

      expect(response).to redirect_to(employee_panel_login_path)
    end
  end
end
