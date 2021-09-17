# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
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
