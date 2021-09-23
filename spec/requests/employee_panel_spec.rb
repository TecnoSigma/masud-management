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
    it 'redirects to main page when exists employee token and have authorization' do
      allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:authorized_profile?) { true }

      get '/gestao/main'

      expect(response).to render_template(:main)
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/gestao/login'

      expect(response).to render_template(:login)
    end
  end
end
