# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel::OperatorPanel::Dashboard', type: :request do
  describe '#index' do
    context 'when is administrator profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'administrator' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is agent profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'agent' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is lecturer profile' do
      it 'renders unauthorized page with http status code 401' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'lecturer' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/401.html.erb"
        )
        expect(response).to have_http_status(401)
      end
    end

    context 'when is operator profile' do
      it 'renders operator dashboard page with http status code 200' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { 'operator' }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context 'when occurs errors' do
      it 'renders internal server error page with http status code 500' do
        allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
        allow_any_instance_of(EmployeePanelController).to receive(:profile) { raise StandardError }

        get '/gestao/operador/dashboard/index'

        expect(response).to render_template(
          file: "#{Rails.root}/app/views/error_pages/500.html.erb"
        )
        expect(response).to have_http_status(500)
      end
    end
  end
end
