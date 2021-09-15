require 'rails_helper'

RSpec.describe Dashboards::Subscribers::MainController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200 when exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = Status::STATUSES[:activated]
        subscriber.save!

        session[:subscriber_code] = subscriber.code

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist subscriber session' do
        get :index

        expect(response).to have_http_status(302) 
      end
    end
  end

  describe '#index' do
    it 'assigns variable containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.status = Status::STATUSES[:activated]
      subscriber.save!

      session[:subscriber_code] = subscriber.code
    
      get :index

      expect(assigns[:subscriber]).to eq(subscriber)
    end
  end
end
