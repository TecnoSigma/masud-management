require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status 200' do
        get :index

        expect(response).to have_http_status(200)
      end
    end

    describe '#chart_data' do
      it 'returns http status 200' do
        get :chart_data, format: :json

        expect(response).to have_http_status(200)
      end
    end

    describe '#seller' do
      it 'returns http status 200' do
        get :seller

        expect(response).to have_http_status(200)
      end
    end

    describe '#hire_seller' do
      it 'returns http status 200' do
        get :hire_seller

        expect(response).to have_http_status(200)
      end
    end

    describe '#contract' do
      it 'returns http status 200' do
        get :contract, format: :pdf

        expect(response).to have_http_status(200)
      end
    end

    describe '#seller_contract' do
      it 'returns http status 200' do
        get :seller_contract, format: :pdf

        expect(response).to have_http_status(200)
      end
    end

    describe '#hire' do
      it 'returns http status 302' do
        get :hire, params: { plan: {key: 'standard', name: 'Standard', price: '100.00' } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#create_seller' do
      it 'returns http status code 302 when pass valid params' do
        new_seller = FactoryBot.attributes_for(:seller)

        post :create_seller, params: { new_seller: new_seller }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when pass invalid params' do
        post :create_seller, params: { new_seller: 'anything' }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#hire' do
    it 'redirects to identification page when plan session is present' do
      get :hire, params: { plan: { key: 'standard', name: 'Standard', price: '100.00' } }

      expect(response).to redirect_to(checkout_identificacao_path)
    end
  end

  describe '#create_seller' do
    it 'creates new seller when pass valid params' do
      new_seller = FactoryBot.attributes_for(:seller)

      post :create_seller, params: { new_seller: new_seller }

      result = Seller.find_by_document(new_seller[:document])

      expect(result).to be_present
    end

    it 'redirects to seller page when pass valid params' do
      new_seller = FactoryBot.attributes_for(:seller)

      post :create_seller, params: { new_seller: new_seller }

      expect(response).to redirect_to(home_representantes_path)
    end

    it 'shows success message when pass valid params' do
      new_seller = FactoryBot.attributes_for(:seller)

      post :create_seller, params: { new_seller: new_seller }

      expect(flash[:notice]).to eq('Cadastro criado com sucesso! Em breve, entraremos em contato!')
    end

    it 'no creates new seller when pass invalid params' do
      post :create_seller

      expect(response).to redirect_to(home_representantes_contratar_path)
    end

    it 'redirects to new seller page when pass invalid params' do
      post :create_seller

      expect(response).to redirect_to(home_representantes_contratar_path)
    end

    it 'shows error message when pass invalid params' do
      post :create_seller

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'no creates new seller when occurs errors' do
      new_seller = FactoryBot.attributes_for(:seller)

      allow(Seller).to receive(:new) { raise StandardError }

      post :create_seller, params: { new_seller: new_seller }

      result = Seller.find_by_document(new_seller[:document])

      expect(result).to be_nil
    end

    it 'redirects to seller page when occurs errors' do
      new_seller = FactoryBot.attributes_for(:seller)

      allow(Seller).to receive(:new) { raise StandardError }

      post :create_seller, params: { new_seller: new_seller }

      expect(response).to redirect_to(home_representantes_contratar_path)
    end

    it 'shows error message when occurs errors' do
      new_seller = FactoryBot.attributes_for(:seller)

      allow(Seller).to receive(:new) { raise StandardError }

      post :create_seller, params: { new_seller: new_seller }
      
      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end
  end

  describe '#chart_data' do
    it 'returns chart in JSON format' do
      expected_result = "{\"title\":\"Dados de homicídio, latrocínio e lesão corporal seguida de morte\",\"subtitle\":\"Brasil - 2019\",\"legend\":\"Mortes\",\"violence_data\":[{\"month\":\"Janeiro\",\"death\":3913},{\"month\":\"Fevereiro\",\"death\":3266},{\"month\":\"Março\",\"death\":3708},{\"month\":\"Abril\",\"death\":3645},{\"month\":\"Maio\",\"death\":3529},{\"month\":\"Junho\",\"death\":3217},{\"month\":\"Julho\",\"death\":3124},{\"month\":\"Agosto\",\"death\":3139},{\"month\":\"Setembro\",\"death\":3323}]}"

      get :chart_data, format: :json

      expect(response.body).to eq(expected_result)
    end
  end
end
