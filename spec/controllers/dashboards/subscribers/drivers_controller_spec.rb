require 'rails_helper'

RSpec.describe Dashboards::Subscribers::DriversController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200 when exist subscriber session' do
        create_subscriber_session

        get :index

        expect(response).to have_http_status(200)
      end

       it 'returns http status code 302 when no exist subscriber session' do
        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#insert' do
      it 'returns http status code 200 when exist subscriber session' do
        create_subscriber_session

        get :insert

        expect(response).to have_http_status(200)
      end

       it 'returns http status code 302 when no exist subscriber session' do
        get :insert

        expect(response).to have_http_status(302)
      end
    end

    describe '#details' do
      it 'returns http status code 200 when exist subscriber session' do
        create_subscriber_session

        driver = FactoryBot.create(:driver)
        subscriber = Subscriber.last
        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

        get :details, params: { driver_id: driver.id }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist subscriber session' do
        driver = FactoryBot.create(:driver)
        subscriber = FactoryBot.create(:subscriber)
        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

        get :details, params: { driver_id: driver.id }

        expect(response).to have_http_status(302)
      end
    end

    describe '#edit' do
      it 'returns http status code 200 when exist subscriber session' do
        create_subscriber_session

        driver = FactoryBot.create(:driver)
        subscriber = Subscriber.last
        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

        get :edit, params: { driver_id: driver.id }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when no exist subscriber session' do
        driver = FactoryBot.create(:driver)
        subscriber = FactoryBot.create(:subscriber)
        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

        get :edit, params: { driver_id: driver.id }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#create' do
      it 'returns http status code 302 when exist subscriber session' do
        create_subscriber_session

        subscriber = Subscriber.last

        vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
        vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

        driver_params = FactoryBot.attributes_for(:driver)

        driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                               avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                               vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

        post :create, params: { driver: driver_params }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when exist subscriber session' do
        vehicle = FactoryBot.create(:vehicle)

        driver_params = FactoryBot.attributes_for(:driver)

        driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                               avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                               vehicle_license_plate: vehicle.license_plate})

        post :create, params: { driver: driver_params }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'DELETE actions' do
    describe '#remove' do
     it 'returns http status code 302 when exist subscriber session' do
        create_subscriber_session

        subscriber = Subscriber.last

        vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
        vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

        driver = FactoryBot.create(:driver,
                                   document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                   avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

        driver.vehicles = [vehicle_1, vehicle_2]
        driver.save!

        delete :remove, params: { driver_id: driver.id }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when no exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
        vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

        driver = FactoryBot.create(:driver,
                                   document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                   avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

        driver.vehicles = [vehicle_1, vehicle_2]
        driver.save!

        delete :remove, params: { driver_id: driver.id }

        result_1 = Vehicle.find(vehicle_1.id)
        result_2 = Vehicle.find(vehicle_2.id)

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'PUT actions' do
    describe '#update' do
      it 'returns http status code 302 when exist subscriber session' do
        create_subscriber_session

        subscriber = Subscriber.last

        vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
        vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

        driver = FactoryBot.create(:driver,
                                   document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                   avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

        driver.vehicles = [vehicle_1, vehicle_2]
        driver.save!

        new_license = '11.222.333.444'

        put :update, params: { driver_id: driver.id, driver: { license: new_license } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when no exist subscriber session' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: Status::STATUSES[:activated])

        vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
        vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

        driver = FactoryBot.create(:driver,
                                   document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                   avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

        driver.vehicles = [vehicle_1, vehicle_2]
        driver.save!

        new_license = '11.222.333.444'

        put :update, params: { driver_id: driver.id, driver: { license: new_license } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#details' do
    it 'assigns variable containing driver data when does exist driver' do
      create_subscriber_session

      driver = FactoryBot.create(:driver)
      subscriber = Subscriber.last
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

      get :details, params: { driver_id: driver.id }

      expect(assigns[:driver]).to be_present
    end
  end

  describe '#remove' do
    it 'deletes driver when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: driver.id }

      result = Driver.find_by_id(driver.id)

      expect(result).to be_nil
    end

    it 'no deletes vehicles when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: driver.id }

      result_1 = Vehicle.find(vehicle_1.id)
      result_2 = Vehicle.find(vehicle_2.id)

      expect(result_1).to be_present
      expect(result_2).to be_present
    end

    it 'shows success message when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: driver.id }

      expect(flash[:notice]).to eq('Dados removidos com sucesso!')
    end

    it 'redirects to drivers page when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: driver.id }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_path)
    end

    it 'no deletes driver when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: 'anything' }

      result = Driver.find_by_id(driver.id)

      expect(result).to be_present
    end

    it 'no deletes vehicles when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: 'anything' }

      result_1 = Vehicle.find(vehicle_1.id)
      result_2 = Vehicle.find(vehicle_2.id)

      expect(result_1).to be_present
      expect(result_2).to be_present
    end

    it 'redirects to driver page when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: driver.id }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_path)
    end

    it 'show error message when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      delete :remove, params: { driver_id: 'anything' }

      expect(flash[:alert]).to eq('Erro ao remover dados!')
    end

    it 'no deletes driver when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      allow(Driver).to receive(:delete) { raise StandardError }

      delete :remove, params: { driver_id: driver.id }

      result = Driver.find_by_id(driver.id)

      expect(result).to be_present
    end

    it 'redirects to driver page when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      allow(Driver).to receive(:delete) { raise StandardError }

      delete :remove, params: { driver_id: driver.id }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_path)
    end

    it 'show error message when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      allow(Driver).to receive(:delete) { raise StandardError }

      delete :remove, params: { driver_id: driver.id }

      expect(flash[:alert]).to eq('Erro ao remover dados!')
    end
  end

  describe '#index' do
    it 'assigns variable containing driver data when does exist driver' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)
      add_vehicle_photos(vehicle)

      driver = FactoryBot.create(:driver, vehicles: [vehicle])

      get :index

      expect(assigns[:drivers]).to eq([driver])
    end

    it 'no assigns variable when no exist driver' do
      create_subscriber_session

      get :index

      expect(assigns[:drivers]).to be_empty
    end
  end

  describe '#edit' do
    it 'assigns variable containing driver data when does exist driver' do
      create_subscriber_session

      driver = FactoryBot.create(:driver)
      subscriber = Subscriber.last
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber, drivers: [driver])

      get :edit, params: { driver_id: driver.id }

      expect(assigns[:driver]).to be_present
    end
  end

  describe '#insert' do
    it 'assigns variable instancing a new driver' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      get :insert

      expect(assigns[:driver]).not_to be_nil
    end
  end

  describe '#create' do
    it 'creates a new driver when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      result = Driver.find_by_license(driver_params[:license])

      expect(result).to be_present
      expect(result.vehicles.size).to eq(2)
      expect(result.avatar.attached?).to eq(true)
      expect(result.document.attached?).to eq(true)
    end

    it 'redirects to driver page when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      driver = Driver.find_by_license(driver_params[:license])

      expect(response).to redirect_to(driver_details_path(driver.id))
    end

    it 'shows success message when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      expect(flash[:notice]).to eq('Dados gravados com sucesso!')
    end

    it 'no creates new subscriber when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver, name: nil)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      result = Driver.find_by_license(driver_params[:license])

      expect(result).to be_nil
    end

    it 'redirects to driver page when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver, name: nil)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_adicionar_path)
    end

    it 'shows error message when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver, name: nil)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      post :create, params: { driver: driver_params }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'no creates new subscriber when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      allow(Driver).to receive(:new) { raise StandardError }

      post :create, params: { driver: driver_params }

      result = Driver.find_by_license(driver_params[:license])

      expect(result).to be_nil
    end

    it 'redirects to driver page when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      allow(Driver).to receive(:new) { raise StandardError }

      post :create, params: { driver: driver_params }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_adicionar_path)
    end

    it 'show error message when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver_params = FactoryBot.attributes_for(:driver)

      driver_params.merge!({ document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                             avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"),
                             vehicle_license_plates: [vehicle_1.license_plate, vehicle_2.license_plate] })

      allow(Driver).to receive(:new) { raise StandardError }

      post :create, params: { driver: driver_params }

      result = Driver.find_by_license(driver_params[:license])

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end
  end

  describe '#update' do
    it 'updates driver data when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      result = Driver.find_by_license(new_license)

      expect(result).to be_present
      expect(result.avatar.attached?).to eq(true)
      expect(result.document.attached?).to eq(true)
    end

    it 'redirects to driver details page when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      expect(response).to redirect_to(driver_details_path(driver.id))
    end

    it 'shows success message when pass valid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      expect(flash[:notice]).to eq('Dados atualizados com sucesso!')
    end

    it 'no updates driver data when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = 'anything'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      result = Driver.find_by_license(new_license)

      expect(result).to be_nil
    end

    it 'redirects to driver edition page when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = 'anything'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_path)
    end

    it 'shows error message when pass invalid params' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = 'anything'

      put :update, params: { driver_id: driver.id, driver: { license: new_license } }

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end

    it 'no updates driver data when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'

      put :update, params: { driver: { license: new_license } }

      result = Driver.find_by_license(new_license)

      expect(result).to be_nil
    end

    it 'redirects to driver edition page when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'


      put :update, params: { driver: { license: new_license } }

      expect(response).to redirect_to(dashboards_assinantes_motoristas_path)
    end

    it 'shows error message when occurs errors' do
      create_subscriber_session

      subscriber = Subscriber.last

      vehicle_1 = FactoryBot.create(:vehicle, subscriber: subscriber)
      vehicle_2 = FactoryBot.create(:vehicle, subscriber: subscriber)

      driver = FactoryBot.create(:driver,
                                 document: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/cnh.png"),
                                 avatar: Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/motorista.png"))

      driver.vehicles = [vehicle_1, vehicle_2]
      driver.save!

      new_license = '11.222.333.444'

      put :update, params: { driver: { license: new_license } }

      expect(flash[:alert]).to eq('Falha ao atualizar dados!')
    end
  end

  def create_subscriber_session
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    session[:subscriber_code] = subscriber.code
  end
end
