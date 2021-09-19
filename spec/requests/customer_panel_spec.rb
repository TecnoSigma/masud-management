# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/painel_do_cliente/logout'

      expect(response).to redirect_to(customer_panel_login_path)
    end
  end

  describe '#main' do
    it 'redirects to main page when exists customer token and have authorization' do
      allow_any_instance_of(CustomerPanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(CustomerPanelController).to receive(:authorized?) { true }

      get '/painel_do_cliente/main'

      expect(response).to render_template(:main)
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/painel_do_cliente/login'

      expect(response).to render_template(:login)
    end
  end
end
