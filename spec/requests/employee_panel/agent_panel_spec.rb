# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::AgentPanelController', type: :request do
  describe '#dashboard' do
    context 'when is administrator profile' do
      it 'renders dashboard page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController)
          .to receive(:profile) { 'Administrator' }

        get '/gestao/agente/dashboard'

        expect(response).to render_template(:dashboard)
      end
    end

    context 'when is agent profile' do
      it 'renders dashboard page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController)
          .to receive(:profile) { 'Agent' }

        get '/gestao/agente/dashboard'

        expect(response).to render_template(:dashboard)
      end
    end

    context 'when is lecturer profile' do
      it 'redirects to 401 page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController)
          .to receive(:profile) { 'Lecturer' }

        get '/gestao/agente/dashboard'

        expect(response)
          .to render_template(file: "#{Rails.root}/app/views/error_pages/401.html.erb")
      end
    end

    context 'when is operator profile' do
      it 'redirects to 401 page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController)
          .to receive(:profile) { 'Operator' }

        get '/gestao/agente/dashboard'

        expect(response)
          .to render_template(file: "#{Rails.root}/app/views/error_pages/401.html.erb")
      end
    end
    
    context 'when occurs errors' do
      it 'redirects to 500 page' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController)
          .to receive(:profile) { raise StandardError }

        get '/gestao/agente/dashboard'

        expect(response)
          .to render_template(file: "#{Rails.root}/app/views/error_pages/500.html.erb")
      end
    end
  end
end
