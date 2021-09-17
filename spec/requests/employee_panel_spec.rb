# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel', type: :request do
  describe '#main' do
    it 'redirects to main page when exists employee token and have authorization' do
      allow_any_instance_of(EmployeePanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(EmployeePanelController).to receive(:authorized?) { true }

      get '/painel_administrativo/main'

      expect(response).to render_template(:main)
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/painel_administrativo/login'

      expect(response).to render_template(:login)
    end
  end
end
