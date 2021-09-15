require 'rails_helper'

RSpec.describe  Dashboards::Sellers::Finance::MainController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist seller session' do
        get :index

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#index' do
    it 'assigns variable containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!
  
      session[:seller_code] = seller.code
    
      get :index
    
      expect(assigns[:seller]).to eq(seller)
    end
  end
end
