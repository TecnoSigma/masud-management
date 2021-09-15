require 'rails_helper'

RSpec.describe Cameras::Dashboards::DriversController, type: :controller do
  describe 'GET actions' do
    describe '#login' do
      it 'returns HTTP status code 200 when doesn\'t exist driver session' do
        session[:driver] = nil

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

    describe '#index' do
      it 'returns HTTP status code 200 when does exist driver session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
        add_vehicle_photos(vehicle)

        driver = FactoryBot.create(:driver, vehicles: [vehicle])

        session[:driver] = driver

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 302 when doesn\'t driver session' do
        session[:driver] = nil

        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#qrcode' do
      it 'returns HTTP status code 200 when does exist driver session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
        add_vehicle_photos(vehicle)

        driver = FactoryBot.create(:driver, vehicles: [vehicle])

        session[:driver] = driver

        get :qrcode

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 302 when doesn\'t driver session' do
        session[:driver] = nil

        get :qrcode

        expect(response).to have_http_status(302)
      end
    end

    describe '#transmission' do
      it 'returns HTTP status code 200 when does exist driver session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
        add_vehicle_photos(vehicle)

        driver = FactoryBot.create(:driver, vehicles: [vehicle])

        session[:driver] = driver

        get :transmission

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 302 when doesn\'t driver session' do
        session[:driver] = nil

        get :transmission

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#login' do
    it 'kills driver session' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      session[:driver] = driver

      get :login

      expect(session[:driver]).to be_nil
    end
  end

  describe '#logout' do
    it 'kill driver session' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      session[:driver] = driver

      get :logout

      expect(session[:driver]).to be_nil
    end

    it 'redirect to driver login page' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
       add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      session[:driver] = driver

      get :logout

      expect(response).to redirect_to(cameras_dashboards_motoristas_login_path)
    end
  end

  describe '#qrcode' do
    it 'assigns variable with driver data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      session[:driver] = driver

      get :qrcode

      expect(assigns[:driver]).to eq(driver)
    end
  end
end
