# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'EmployeePanel', type: :request do
  describe '#logout' do
    it 'redirects to customer login page' do
      get '/gestao/logout'

      expect(response).to redirect_to(employee_panel_login_path)
    end
  end

  describe '#logout' do
    it 'renders to login page' do
      get '/gestao/logout'

      expect(response).to redirect_to(employee_panel_login_path)
    end
  end
end
