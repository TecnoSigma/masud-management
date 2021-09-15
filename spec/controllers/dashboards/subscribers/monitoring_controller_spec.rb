require 'rails_helper'

RSpec.describe Dashboards::Subscribers::MonitoringController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :index

        expect(response).to have_http_status(302)
      end

      it 'returns http status 200 when does exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)

        session[:subscriber_code] = subscriber.code

        get :index

        expect(response).to have_http_status(200)
      end
    end
  end

  describe '#index' do
    it 'redirect to dashboard login when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :index

        expect(response).to redirect_to(login_assinantes_path)
    end

    it 'assigns variable containing subscriber data' do
      subscriber = FactoryBot.create(:subscriber)

      session[:subscriber_code] = subscriber.code

      get :index

      expect(assigns[:subscriber]).to be_present
    end
  end
end
