require 'rails_helper'

RSpec.describe Cameras::LoginsController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns HTTP status code 200' do
        get :index

        expect(response).to have_http_status(200)
      end
    end

    describe '#driver_names' do
      it 'returns HTTP status code 200 when pass valid param in JSON format' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
        add_vehicle_photos(vehicle)

        driver = FactoryBot.create(:driver, vehicles: [vehicle])

        angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

        get :driver_names, params: { angel_document: angel.cpf }, format: :json

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 200 when occurs some errors' do
        allow(Angel).to receive(:find_by_cpf) { raise StandardError }

        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
        add_vehicle_photos(vehicle)

        driver = FactoryBot.create(:driver, vehicles: [vehicle])

        angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

        get :driver_names, params: { angel_document: angel.cpf }, format: :json

        expect(response).to have_http_status(200)
      end
    end

    describe 'POST actions' do
      describe '#validate_angels_access' do
        it 'returns HTTP  status code 302 when pass valid params' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
          add_vehicle_photos(vehicle)

          driver = FactoryBot.create(:driver, vehicles: [vehicle])

          angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

          post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP  status code 302 when pass invalid params' do
          post :validate_angels_access, params: { angel: { document: nil, driver: nil } }

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP  status code 302 when occurs some errors' do
          allow(Angel).to receive(:find_by_cpf) { raise StandardError }

          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
          add_vehicle_photos(vehicle)

          driver = FactoryBot.create(:driver, vehicles: [vehicle])

          angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

          post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

          expect(response).to have_http_status(302)
        end
      end

      describe '#validate_drivers_access' do
        it 'returns HTTP  status code 302 when pass valid params' do
          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
          add_vehicle_photos(vehicle)

          driver = FactoryBot.create(:driver, vehicles: [vehicle])

          angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

          post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP  status code 302 when pass invalid params' do
          post :validate_drivers_access, params: { driver: { driver_license: nil, license_plate: nil } }

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP  status code 302 when occurs some errors' do
          allow(Angel).to receive(:find_by_cpf) { raise StandardError }

          subscriber = FactoryBot.create(:subscriber)
          subscriber.update_attributes!(status: Status::STATUSES[:activated])

          vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
          add_vehicle_photos(vehicle)

          driver = FactoryBot.create(:driver, vehicles: [vehicle])

          angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

          post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe '#driver_names' do
    it 'returns driver data list in JSON format when pass valid param' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      get :driver_names, params: { angel_document: angel.cpf }, format: :json

      expect(response.body).to eq("[[\"#{driver.license}\",\"#{driver.name}\"]]")
    end

    it 'returns empty list in JSON format when occurs some errors' do
      allow(Angel).to receive(:find_by_cpf) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      get :driver_names, params: { angel_document: angel.cpf }, format: :json

      expect(response.body).to eq("[]")
    end
  end

  describe '#validate_angels_access' do
    it 'redirect to angel dashboard when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

      expect(response).to redirect_to(cameras_dashboards_angels_path)
    end

    it 'creates sessions containing angel and driver data when pass angel and driver params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

      expect(session[:angel]).to be_present
      expect(session[:driver]).to be_present
    end

    it 'creates sessions containing only angel data when pass only angel params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: angel.cpf, driver: nil } }

      expect(session[:angel]).to be_present
      expect(session[:driver]).to be_nil
    end

    it 'no create sessions containing angel and driver data when pass only driver params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: 'anything', driver: driver.license } }

      expect(session[:angel]).to be_nil
      expect(session[:driver]).to be_nil
    end

    it 'no create sessions containing angel and driver data when no pass angel and driver params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: nil, driver: nil } }

      expect(session[:angel]).to be_nil
      expect(session[:driver]).to be_nil
    end

    it 'redirect to angels login page when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: nil, driver: nil } }

      expect(response).to redirect_to(cameras_logins_angels_path)
    end

    it 'show error message when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: 'anything', driver: 'anything' } }

      expect(flash[:alert]).to eq('Dados de acesso incorretos!')
    end

    it 'redirect to angels login page when occurs some errors' do
      allow(Angel).to receive(:find_by_cpf) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

      expect(response).to redirect_to(cameras_logins_angels_path)
    end

    it 'show error message when occurs some errors' do
      allow(Angel).to receive(:find_by_cpf) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_angels_access, params: { angel: { document: angel.cpf, driver: driver.license } }

      expect(flash[:alert]).to eq('Falha no acesso ao dashboard!')
    end
  end

  describe '#validate_drivers_access' do
    it 'redirect to driver dashboard when pass valid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

      expect(response).to redirect_to(cameras_dashboards_motoristas_path)
    end

    it 'creates sessions containing driver and vehicle data when pass driver and vehicle params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

      expect(session[:driver]).to be_present
      expect(session[:vehicle]).to be_present
    end

    it 'no create sessions containing driver and vehicle data when pass only driver params as valid data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: 'anything' } }

      expect(session[:driver]).to be_nil
      expect(session[:vehicle]).to be_nil
    end

    it 'no create sessions containing driver and vehicle data when pass only vehicle params as valid data' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: 'anything', license_plate: vehicle.license_plate } }

      expect(session[:driver]).to be_nil
      expect(session[:vehicle]).to be_nil
    end

    it 'no create sessions containing driver and vehicle data when no pass driver and vehicle params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: nil, license_plate: nil } }

      expect(session[:driver]).to be_nil
      expect(session[:vehicle]).to be_nil
    end

    it 'redirect to drivers login page when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: nil, license_plate: nil } }

      expect(response).to redirect_to(cameras_dashboards_motoristas_login_path)
    end

    it 'show error message when pass invalid params' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: 'anything', license_plate: 'anything' } }

      expect(flash[:alert]).to eq('Dados de acesso incorretos!')
    end

    it 'redirect to drivers login page when occurs some errors' do
      allow(Driver).to receive(:find_by_license) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

      expect(response).to redirect_to(cameras_dashboards_motoristas_login_path)
    end

    it 'show error message when occurs some errors' do
      allow(Driver).to receive(:find_by_license) { raise StandardError }

      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: Status::STATUSES[:activated])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      angel = FactoryBot.create(:angel, subscriber: subscriber, drivers: [driver])

      post :validate_drivers_access, params: { driver: { driver_license: driver.license, license_plate: vehicle.license_plate } }

      expect(flash[:alert]).to eq('Falha no acesso ao dashboard!')
    end
  end
end
