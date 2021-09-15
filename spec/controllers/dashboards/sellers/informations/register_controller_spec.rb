require 'rails_helper'

RSpec.describe Dashboards::Sellers::Informations::RegisterController, type: :controller do
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

    describe '#edit' do
      it 'returns http status code 200 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        get :edit

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist seller session' do
        get :edit

        expect(response).to have_http_status(302)
      end
    end

    describe '#update' do
      it 'returns http status code 302 when exist seller session' do
        seller = FactoryBot.create(:seller)
        seller.status = Status::STATUSES[:activated]
        seller.save!

        session[:seller_code] = seller.code

        seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

        put :update, params: { seller: seller_attributes }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when no exist seller session' do
        get :index

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#update' do
    it 'updates seller data when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: seller_attributes }

      result = Seller.find_by_code(session[:seller_code])

      expect(result.name).to eq(seller_attributes[:name])
      expect(result.password).not_to eq(seller_attributes[:password])
      expect(result.core_register).to eq(seller_attributes[:core_register])
      expect(result.expedition_date).to eq(seller_attributes[:expedition_date])
      expect(result.expiration_date).to eq(seller_attributes[:expiration_date])
      expect(result.document).not_to eq(seller_attributes[:document])
      expect(result.code).to eq(seller_attributes[:code])
      expect(result.address).to eq(seller_attributes[:address])
      expect(result.number).to eq(seller_attributes[:number])
      expect(result.complement).to eq(seller_attributes[:complement])
      expect(result.district).to eq(seller_attributes[:district])
      expect(result.city).to eq(seller_attributes[:city])
      expect(result.state).to eq(seller_attributes[:state])
      expect(result.postal_code).to eq(seller_attributes[:postal_code])
      expect(result.cellphone).to eq(seller_attributes[:cellphone])
      expect(result.email).to eq(seller_attributes[:email])
      expect(result.status).to eq(seller_attributes[:status])
    end

    it 'redirects to seller register dashboard whem pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: seller_attributes }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_cadastro_path)
    end

    it 'shows success message when pass valid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: seller_attributes }

      expect(flash[:notice]).to eq('Dados atualizados com sucesso!')
    end

    it 'no update seller data when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: 'anything' }

      result = Seller.find_by_code(session[:seller_code])

      expect(result).to eq(seller)
    end

    it 'redirects to seller register dashboard when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: 'anything' }

      expect(response).to redirect_to(dashboards_representantes_informacoes_pessoais_cadastro_path)
    end

    it 'shows error message when pass invalid params' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      seller_attributes = FactoryBot.attributes_for(:seller, code: seller.code )

      put :update, params: { seller: 'anything' }

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
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

  describe '#edit' do
    it 'assigns variable containing seller data' do
      seller = FactoryBot.create(:seller)
      seller.status = Status::STATUSES[:activated]
      seller.save!

      session[:seller_code] = seller.code

      get :edit

      expect(assigns[:seller]).to eq(seller)
    end
  end
end
