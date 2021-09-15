require 'rails_helper'

RSpec.describe Dashboards::Subscribers::VehiclesController, type: :controller do
  describe 'GET actions' do
    describe '#index' do
      it 'returns http status code 200' do
        create_subscriber_session

        get :index

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :index

        expect(response).to have_http_status(302)
      end
    end

    describe '#add_photos' do
      it 'returns http status code 200' do
        create_subscriber_session

        subscriber = Subscriber.find_by_code(session[:subscriber_code])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

        get :add_photos, params: { vehicle_id: vehicle.id }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :add_photos, params: { vehicle_id: 'any_id' }

        expect(response).to have_http_status(302)
      end
    end

    describe '#details' do
      it 'returns http status code 200' do
        create_subscriber_session

        subscriber = Subscriber.find_by_code(session[:subscriber_code])

        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

        get :details, params: { vehicle_id: vehicle.id }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 302 when doesn\'t exist subscriber session' do
        session[:subscriber_code] = nil

        get :details, params: { vehicle_id: 'any_id' }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#upload_photos' do
      it 'returns http status code 302 when not exist subscriber session' do

        post :upload_photos, params: { vehicle: { id: 'any_id',
                                                  photos: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")] } }
        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when upload photos' do
        create_subscriber_session

        subscriber = Subscriber.find_by_code(session[:subscriber_code])
        vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

        post :upload_photos, params: { vehicle: { id: vehicle.id,
                                                  photos: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")] } }

        expect(response).to have_http_status(302)
      end

      it 'returns http status code 302 when not exist vehicles' do
        create_subscriber_session

        post :upload_photos, params: { vehicle: { id: 'any_id',
                                                  photos: [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                                                           Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")] } }

        expect(response).to have_http_status(302)
      end
    end
  end

  describe '#details' do
    it 'assigns variable with vehicle data when exist vehicle' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      get :details, params: { vehicle_id: vehicle.id }

      expect(assigns[:vehicle]).to be_present
    end

    it 'no assign variable when not exist vehicle' do
      create_subscriber_session

      get :details, params: { vehicle_id: 'any_id'  }

      expect(assigns[:vehicle]).to be_nil
    end

    it 'redirect to vehicles page when not exist vehicle' do
      create_subscriber_session

      get :details, params: { vehicle_id: 'any_id'  }

      expect(response).to redirect_to(dashboards_assinantes_veiculos_path)
    end

    it 'shows error message when not exist vehicle' do
      create_subscriber_session

      get :details, params: { vehicle_id: 'any_id'  }

      expect(flash[:alert]).to eq('Erro ao localizar dados!')
    end
  end

  describe '#add_photos' do
    it 'assigns variable with vehicle data when exist vehicle' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])

      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      get :add_photos, params: { vehicle_id: vehicle.id }

      expect(assigns[:vehicle]).to be_present
    end

    it 'no assign variable when not exist vehicle' do
      create_subscriber_session

      get :add_photos, params: { vehicle_id: 'any_id'  }

      expect(assigns[:vehicle]).to be_nil
    end

    it 'redirect to vehicles page when not exist vehicle' do
      create_subscriber_session

      get :add_photos, params: { vehicle_id: 'any_id'  }

      expect(response).to redirect_to(dashboards_assinantes_veiculos_path)
    end

    it 'shows error message when not exist vehicle' do
      create_subscriber_session

      get :add_photos, params: { vehicle_id: 'any_id'  }

      expect(flash[:alert]).to eq('Erro ao localizar dados!')
    end
  end

  describe '#upload_photos' do
    it 'attaches vehicle photos when pass valid params' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { id: vehicle.id, photos: file_list } }

      result = vehicle.photos.count

      expect(result).to eq(file_list.count)
    end

    it 'shows success message when pass valid params' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { id: vehicle.id, photos: file_list } }

      expect(flash[:notice]).to eq('Dados gravados com sucesso!')
    end

    it 'redirects to vehicles dashboard when passa valid params' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { id: vehicle.id, photos: file_list } }

      expect(response).to redirect_to(dashboards_assinantes_veiculos_path)
    end

    it 'shows errors message when no exist vehicle' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])

      post :upload_photos, params: { vehicle: { id: 'any_id', photos: [] } }

      expect(flash[:alert]).to eq('Erro ao localizar dados!')
    end

    it 'redirects to vehicle dashboard when no exist vehicle' do
      create_subscriber_session

      subscriber = Subscriber.find_by_code(session[:subscriber_code])

      post :upload_photos, params: { vehicle: { id: 'any_id', photos: [] } }

      expect(response).to redirect_to(dashboards_assinantes_veiculos_path)
    end

    it 'no attach vehicle photos when occurs errors' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { } }

      expect(vehicle.photos.count).to eq(0)
    end

    it 'show error message when occurs errors' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { } }

      expect(flash[:alert]).to eq('Erro ao gravar dados!')
    end

    it 'redirects to vehicle dashboard when occurs errors' do
      create_subscriber_session

      file_list = [Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/front_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/lateral_photo.jpg"),
                   Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/back_photo.jpg")]

      subscriber = Subscriber.find_by_code(session[:subscriber_code])
      vehicle = FactoryBot.create(:vehicle, subscriber: subscriber)

      post :upload_photos, params: { vehicle: { } }

      expect(response).to redirect_to(dashboards_assinantes_veiculos_path)
    end
  end

  def create_subscriber_session
    subscriber = FactoryBot.create(:subscriber)
    subscriber.status = Status::STATUSES[:activated]
    subscriber.save!

    session[:subscriber_code] = subscriber.code
  end
end
