require 'rails_helper'

RSpec.describe Dashboards::Subscribers::Informations::RegisterController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#edit' do
      it 'returns http status code 200' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!
      
        session[:subscriber_code] = subscriber.code
        
        get :edit
      
        expect(response).to have_http_status(200)
      end
      
      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil
    
        get :edit
  
        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#index' do
    it 'returns assign @subscriber containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!
 
      session[:subscriber_code] = subscriber.code
 
      get :index

      expect(assigns[:subscriber]).to eq(subscriber)
    end
  end

  describe '#edit' do
    it 'returns assign @subscriber containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :edit

      expect(assigns[:subscriber]).to eq(subscriber)
    end
  end

  describe 'PUT actions' do
    describe '#update' do
      it 'updates subscriber data when pass valid params' do
        subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        new_city = 'Manaus'

        session[:subscriber_code] = subscriber.code

        allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

        put :update, params: { subscriber: { city: new_city } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#update' do
    it 'updates subscriber data when pass valid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      new_city = 'Manaus'

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: new_city } }

      result = Subscriber.find_by_code(subscriber.code).city

      expect(result).to eq(new_city)
    end

    it 'shows success message when pass valid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      new_city = 'Manaus'

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: new_city } }

      expect(flash[:notice]).to eq('Dados atualizados com sucesso!')
    end

    it 'redirects to subscriber page when pass valid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      new_city = 'Manaus'

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: new_city } }

      expect(response).to redirect_to(dashboards_assinantes_informacoes_pessoais_cadastro_path)
    end

    it 'no updates subscriber data when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: nil } }

      result = Subscriber.find_by_code(subscriber.code).city

      expect(result).to eq(subscriber.city)
    end

    it 'shows errors message when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: nil } }

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end

    it 'redirects to subscriber page when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }

      put :update, params: { subscriber: { city: nil } }

      expect(response).to redirect_to(dashboards_assinantes_informacoes_pessoais_cadastro_path)
    end

    it 'no updates subscriber data when occurs errors in payment gateway' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      new_city = 'Manaus'

      session[:subscriber_code] = subscriber.code

      allow(Gateways::Payment::Subscriber).to receive(:update!) { false }

      put :update, params: { subscriber: { city: new_city } }

      result = Subscriber.find_by_code(subscriber.code).city

      expect(result).not_to eq(new_city)
    end

    it 'no updates subscriber data when occurs errors' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!
  
      new_city = 'Manaus'
      
      session[:subscriber_code] = subscriber.code
      
      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }
    
      put :update, params: { subscriber: nil }
    
      result = Subscriber.find_by_code(subscriber.code).city
    
      expect(result).not_to eq(new_city)
    end

    it 'shows errors message when occurs errors' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!
  
      new_city = 'Manaus'
      
      session[:subscriber_code] = subscriber.code
      
      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }
    
      put :update, params: { subscriber: nil }
    
      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end

    it 'redirects to subscriber page when occurs errors' do
      subscriber = FactoryBot.create(:subscriber, city: 'São Paulo')
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!
  
      new_city = 'Manaus'
      
      session[:subscriber_code] = subscriber.code
      
      allow(Gateways::Payment::Subscriber).to receive(:update!) { true }
    
      put :update, params: { subscriber: nil }
    
      expect(response).to redirect_to(dashboards_assinantes_informacoes_pessoais_cadastro_path)
    end
  end
end
