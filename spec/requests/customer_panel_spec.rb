require 'rails_helper'

RSpec.describe 'CustomerPanel', type: :request do
  describe '#login' do
    it 'renders to login page' do
      get '/painel_do_cliente/login'

      expect(response).to render_template(:login)
    end
  end
end
