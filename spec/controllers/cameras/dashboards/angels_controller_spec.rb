require 'rails_helper'

RSpec.describe Cameras::Dashboards::AngelsController, type: :controller do
  describe 'GET actions' do
    describe '#login' do
      it 'returns HTTP status code 200 when doesn\'t exist angel session' do
        session[:angel] = nil

        get :login

        expect(response).to have_http_status(200)
      end
    end

    describe '#logout' do
      it 'returns HTTP status code 302' do
        get :logout

        expect(response).to have_http_status(302)
      end
    end

    describe '#driver' do
      it 'returns HTTP status code 200 when does exist angel session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        driver = FactoryBot.create(:driver)

        angel = FactoryBot.create(:angel, subscriber: subscriber)

        session[:angel] = angel
        session[:driver] = driver

        get :driver

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 302 when doesn\'t angel session' do
        session[:angel] = nil

        get :driver

        expect(response).to have_http_status(302)
      end
    end

    describe '#index' do
      it 'returns HTTP status code 200 when does exist angel session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        angel = FactoryBot.create(:angel, subscriber: subscriber)

        session[:angel] = angel

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 302 when doesn\'t angel session' do
        session[:angel] = nil

        get :index

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#login' do
    it 'kills angel session' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      session[:angel] = angel

      get :login

      expect(session[:angel]).to be_nil
    end
  end

  describe '#logout' do
    it 'kill angel session' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      session[:angel] = angel

      get :logout

      expect(session[:angel]).to be_nil
    end

    it 'redirect to angel login page' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      session[:angel] = angel

      get :logout

      expect(response).to redirect_to(cameras_dashboards_angels_login_path)
    end
  end

  describe '#driver' do
    it 'assigns variable with driver data when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      driver = FactoryBot.create(:driver)

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      session[:angel] = angel
      session[:driver] = driver

      get :driver

      expect(assigns[:driver]).to be_present
    end

    it 'redirect to angel login page when no exist angel session' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      driver = FactoryBot.create(:driver)

      angel = FactoryBot.create(:angel, subscriber: subscriber)

      session[:driver] = driver

      get :driver

      expect(response).to redirect_to(cameras_dashboards_angels_login_path)
    end
  end
end
