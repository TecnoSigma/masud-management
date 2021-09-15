require 'rails_helper'

RSpec.describe Dashboards::Sellers::Informations::DocumentsController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!
  
        session[:seller_code] = seller.code

        get :index

        expect(response).to have_http_status(200)
      end
      it 'returns http status code 302 when doesn\'t exist seller session' do
        session[:seller_code] = nil

        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#contract' do
      it 'returns http status code 200' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :contract, format: :pdf

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist seller session' do
        session[:seller_code] = nil

        get :contract, format: :pdf

        expect(response).to have_http_status(302)
      end
    end

    describe '#distract' do
      it 'returns http status code 200' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :distract, format: :pdf

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist seller session' do
        session[:seller_code] = nil

        get :distract, format: :pdf

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#index' do
    it 'returns assign @seller containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!
 
      session[:seller_code] = seller.code
 
      get :index

      expect(assigns[:seller]).to eq(seller)
    end
  end

  describe '#contract' do
    it 'returns assign @seller containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      get :contract, format: :pdf

      expect(assigns[:seller]).to eq(seller)
    end
  end

  describe '#distract' do
    it 'returns assign @seller containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      get :distract, format: :pdf

      expect(assigns[:seller]).to eq(seller)
    end
  end
end
