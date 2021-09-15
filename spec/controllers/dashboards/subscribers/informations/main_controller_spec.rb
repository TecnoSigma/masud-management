require 'rails_helper'

RSpec.describe Dashboards::Subscribers::PersonalInformations::MainController, type: :controller do
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
  end
end
