require 'rails_helper'

RSpec.describe Dashboards::Subscribers::Informations::DocumentsController, type: :controller do
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

    describe '#contract' do
      it 'returns http status code 200' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :contract, format: :pdf

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :contract, format: :pdf

        expect(response).to have_http_status(302)
      end
    end

    describe '#distract' do
      it 'returns http status code 200' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :distract, format: :pdf

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :distract, format: :pdf

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

  describe '#contract' do
    it 'returns assign @subscriber containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :contract, format: :pdf

      expect(assigns[:subscriber]).to eq(subscriber)
    end
  end

  describe '#distract' do
    it 'returns assign @subscriber containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code

      get :distract, format: :pdf

      expect(assigns[:subscriber]).to eq(subscriber)
    end
  end
end
