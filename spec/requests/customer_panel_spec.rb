# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/cliente/logout'

      expect(response).to redirect_to(customer_panel_login_path)
    end
  end

  describe '#main' do
    it 'redirects to main page when exists customer token and have authorization' do
      allow_any_instance_of(CustomerPanelController).to receive(:tokenized?) { true }
      allow_any_instance_of(CustomerPanelController).to receive(:authorized?) { true }

      get '/cliente/dashboard/index'

      expect(response).to render_template(:index)
    end
  end

  describe '#login' do
    it 'renders to login page' do
      get '/cliente/login'

      expect(response).to render_template(:login)
    end
  end

  describe '#cities' do
    it 'returns cities list in JSON format' do
      state = FactoryBot.create(:state)
      city = FactoryBot.create(:city, state: state)

      customer = FactoryBot.create(:customer)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/cities', params: { state_id: state.id }

      expect(response.body).to eq("{\"cities\":[\"#{city.name}\"]}")
      expect(response).to have_http_status(200)
    end

   it 'returns empty list wehn occurs errors' do
      customer = FactoryBot.create(:customer)

      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/cities'

      expect(response.body).to eq("{\"cities\":[]}")
      expect(response).to have_http_status(500)
    end
  end
end
