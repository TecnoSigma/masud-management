# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'CustomerPanel::Escort', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/cliente/logout'

      expect(response).to redirect_to(customer_panel_login_path)
    end
  end

  describe '#list' do
    it 'renders escorts list page' do
      customer = FactoryBot.create(:customer)
      allow_any_instance_of(PanelsController).to receive(:tokenized?) { true }
      allow_any_instance_of(PanelsController).to receive(:authorized?) { true }
      allow_any_instance_of(CustomerPanel::EscortController).to receive(:customer) { customer }

      get '/cliente/dashboard/escolta/lista'

      expect(response).to render_template(:list)
    end
  end
end
