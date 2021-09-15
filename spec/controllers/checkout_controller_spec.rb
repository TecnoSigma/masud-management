require 'rails_helper'

RSpec.describe CheckoutController, type: :controller do
  describe 'GET actions' do
    describe '#vehicles' do
      it 'returns HTTP status 302 when not pass plan informations' do
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_list_session

        get :vehicles

        expect(response).to have_http_status(302)

      end

      it 'returns HTTP status 302 when not pass subscriber informations' do
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_list_session

        get :vehicles

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 200 when pass valid params' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_list_session

        get :vehicles

        expect(response).to have_http_status(200)
      end
    end

    describe '#check_seller' do
      it 'returns http status code 200 when pass valid params' do
        seller = FactoryBot.create(:seller, status: Status::STATUSES[:activated])

        get :check_seller, params: { seller_cpf: seller.document }

        expect(response).to have_http_status(200)
      end

      it 'returns http status code 500 when ocurrs errors' do
        seller = FactoryBot.create(:seller, status: Status::STATUSES[:activated])

        allow(Seller).to receive(:activated) { raise StandardError }

        get :check_seller, params: { seller_document: seller.document }

        expect(response).to have_http_status(500)
      end
    end

    describe 'vehicle_model_list' do
      it 'returns HTTP status 302 when not pass plan informations' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
        vehicle_model = FactoryBot.create(:vehicle_model,
                                          kind: 'Fusca',
                                          vehicle_brand: vehicle_brand)

        get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when not pass subscriber informations' do
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
        vehicle_model = FactoryBot.create(:vehicle_model,
                                          kind: 'Fusca',
                                          vehicle_brand: vehicle_brand)

        get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 200 when pass valid params' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
        vehicle_model = FactoryBot.create(:vehicle_model,
                                          kind: 'Fusca',
                                          vehicle_brand: vehicle_brand)

        get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status 200 when occurs some errors' do
        allow(VehicleBrand).to receive(:find_by_brand) { raise StandardError }

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', code:  10.0 }

        vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
        vehicle_model = FactoryBot.create(:vehicle_model,
                                          kind: 'Fusca',
                                          vehicle_brand: vehicle_brand)

        get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

        expect(response).to have_http_status(200)
      end
    end

    describe '#identification' do
      it 'returns HTTP status 200 when plan session is created' do
        session[:plan] = { name: 'Standard', price: 10.2 }

        get :identification

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status 302 when plan session isn\'t created' do
        get :identification

        expect(response).to have_http_status(302)
      end
    end

    describe '#subscriber_address' do
      it 'returns HTTP status code 200 when pass valid postal code' do
        postal_code = '04354-100'
        address_result = { neighborhood: "Vila Cordeiro",
                           zipcode: "04583100",
                           city: "São Paulo",
                           address: "Avenida Jurubatuba",
                           state: "SP",
                           complement: ""}

        allow(Correios::CEP::AddressFinder)
          .to receive(:get)
          .with(postal_code) { address_result }

        get :subscriber_address, params: { postal_code: postal_code }, format: :json

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status code 200 when pass invalid postal code' do
        postal_code = 'abcd'

        allow(Correios::CEP::AddressFinder)
          .to receive(:get)
          .with(postal_code) {{}}

        get :subscriber_address, params: { postal_code: postal_code }, format: :json

       expect(response).to have_http_status(200)
      end
    end

    describe '#resume' do
      it 'returns HTTP status 200 when plan session AND subscriber session are created' do
        session[:plan] = { name: 'standard', code:  10.0 }
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        get :resume

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status 302 when only subscriber session is created' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        get :resume

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when plan session AND subscriber session aren\'t created' do
        get :resume

        expect(response).to have_http_status(302)
      end
    end

    describe '#finalization' do
      it 'returns HTTP statuus 200 when plan session AND subscriber session are created' do
        allow(Notifications::Hiring).to receive_message_chain(:finalization, :deliver_now!) { true }

        session[:plan] = { name: 'standard', code:  10.0 }
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        get :finalization

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status 302 when only subscriber session is created' do
        allow(Notifications::Hiring).to receive_message_chain(:finalization, :deliver_now!) { true }

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        get :finalization

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when plan session AND subscriber session aren\'t created' do
        allow(Notifications::Hiring).to receive_message_chain(:finalization, :deliver_now!) { true }

        get :finalization

        expect(response).to have_http_status(302)
      end
    end

    describe '#payment' do
      it 'returns HTTP status 200 when plan session AND subscriber session are created' do
        session[:plan] = { name: 'standard', price: 100.0 }
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        allow(Freight).to receive(:calculate) { '10.00' }

        get :payment

        expect(response).to have_http_status(200)
      end

      it 'returns HTTP status 302 when only plan session is created' do
        session[:plan] = { name: 'standard', code:  10.0 }

        get :payment

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when only subscriber session is created' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)

        get :payment

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when plan session AND subscriber session aren\'t created' do
        get :payment

        expect(response).to have_http_status(302)
      end
    end
  end

  describe 'POST actions' do
    describe '#find_subscriber_data' do
      it 'returns HTTP status 302 when plan session is created' do
        session[:plan] = { name: 'Standard', price: 10.2 }

        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: 'ativado')

        post :find_subscriber_data, params: { user: subscriber.user, password: subscriber.password }

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when plan session isn\'t created' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.update_attributes!(status: 'ativado')

        post :find_subscriber_data, params: { user: subscriber.user, password: subscriber.password }

        expect(response).to have_http_status(302)
      end
    end

    describe '#subscriber_info' do
      it 'returns HTTP status 302 when pass valid params' do
        valid_params = FactoryBot.attributes_for(:subscriber)

        post :subscriber_info, params: { subscriber: valid_params }

        expect(response).to have_http_status(302)
      end

      it 'returns HTTP status 302 when pass invalid params' do
        invalid_params = FactoryBot.attributes_for(:subscriber, name: nil)

        post :subscriber_info, params: { subscriber: invalid_params }

        expect(response).to have_http_status(302)
      end
    end

    describe '#process_payment' do
      context 'when does exist subscriber' do
        it 'returns HTTP status 302 when save new subscriber' do
          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          payment_params = { payment_method: 'Cartão de Crédito' ,
                             credit_card_number: '5484788254314887',
                             expiration_month: '06',
                             expiration_year: 'DateTime.now.year + 5',
                             holder_name: 'JOAO F DA SILVA' }

          post :process_payment, params: payment_params

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP status 302 when not save new subscriber' do
          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          post :process_payment, params: {}

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP status code 302 when occurs some errors' do
          allow(Subscriber).to receive(:new) { raise StandardError }

          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          payment_params = { payment_method: 'Cartão de Crédito' ,
                             credit_card_number: '5484788254314887',
                             expiration_month: '06',
                             expiration_year: 'DateTime.now.year + 5',
                             holder_name: 'JOAO F DA SILVA' }

          post :process_payment, params: payment_params

          expect(response).to have_http_status(302)
        end
      end

      context 'when doesn\'t exist subscriber' do
        it 'returns HTTP status 302 when save new subscriber' do
          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          payment_params = { payment_method: 'Cartão de Crédito' ,
                             credit_card_number: '5484788254314887',
                             expiration_month: '06',
                             expiration_year: 'DateTime.now.year + 5',
                             holder_name: 'JOAO F DA SILVA' }

          post :process_payment, params: payment_params

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP status 302 when not save new subscriber' do
          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          post :process_payment, params: {}

          expect(response).to have_http_status(302)
        end

        it 'returns HTTP status code 302 when occurs some errors' do
          session[:plan] = { 'name' => 'standard', 'price' => 100.0, 'code' => 'plan-code' }
          session[:subscriber] = { 'postal_code' => '04842-100' }
          session[:vehicle_list] = [ { 'brand' => 'Volks',
                                       'kind' => 'Fusca',
                                       'license_plate' => 'ABC-1000' },
                                     { 'brand' => 'Ford',
                                       'kind' => 'Palio',
                                       'license_plate' => 'XYZ-9999' } ]

          allow(Subscriber).to receive(:new) { raise StandardError }

          payment_params = { payment_method: 'Cartão de Crédito' ,
                             credit_card_number: '5484788254314887',
                             expiration_month: '06',
                             expiration_year: 'DateTime.now.year + 5',
                             holder_name: 'JOAO F DA SILVA' }

          post :process_payment, params: payment_params

          expect(response).to have_http_status(302)
        end
      end
    end
  end

  describe '#identification' do
    it 'redirects to root page when plan session isn\'t created' do
      get :identification

      expect(response).to redirect_to(root_path)
    end
  end

  describe '#resume' do
    it 'redirects to root page when plan session isn\'t created' do
      get :resume

      expect(response).to redirect_to(root_path)
    end

    it 'returns a session containing subscriber IP' do
      ip = '127.0.0.1'

      allow(Services::IpClient).to receive(:ip) { ip }

      session[:plan] = { name: 'standard', code:  10.0 }
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)

      get :resume

      result = session[:subscriber]['ip']

      expect(result).to eq(ip)
    end
  end

  describe '#payment' do
    it 'redirects to root page when plan session isn\'t created' do
      get :payment

      expect(response).to redirect_to(root_path)
    end

    it 'assigns variable with freight value' do
      session[:plan] = { name: 'standard', price: 100.0 }
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:vehicle_list] = [ { 'brand' => 'Volks',
                                    'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

      allow(Freight).to receive(:calculate) { '10.00' }

      get :payment

      expect(assigns[:freight]).to be_present
    end
  end

  describe '#check_seller' do
    it 'returns \'true\' when exist seller' do
      seller = FactoryBot.create(:seller, status: Status::STATUSES[:activated])

      get :check_seller, params: { seller_cpf: seller.document }

      expect(response.body).to eq('true')
    end

    it 'returns \'false\' when no exist seller' do
      get :check_seller, params: { seller_cpf: '123.456.789-00'  }

      expect(response.body).to eq('false')
    end

    it 'returns \'false\' when ocurrs errors' do
      seller = FactoryBot.create(:seller, status: Status::STATUSES[:activated])

      allow(Seller).to receive(:activated){ raise StandardError }

      get :check_seller, params: { seller_cpf: seller.document }

      expect(response.body).to eq('false')
    end
  end

  describe '#subscriber_info' do
    it 'redirects to root page when plan session isn\'t created' do
      valid_params = FactoryBot.attributes_for(:subscriber)

      post :subscriber_info, params: { subscriber: valid_params }

      expect(response).to redirect_to(root_path)
    end

    it 'redirects to vehicle page when pass plan name as param and plan session is created' do
      valid_params = FactoryBot.attributes_for(:subscriber)

      session[:plan] = { name: 'standard', price: 10.0 }

      post :subscriber_info, params: { new_subscriber: valid_params }

      expect(response).to redirect_to(checkout_veiculos_path)
    end

    it 'creates session with subscriber info when pass valid params' do
      valid_params = FactoryBot.attributes_for(:subscriber)

      session[:plan] = { name: 'standard', price: 10.0 }

      post :subscriber_info, params: { new_subscriber: valid_params }

      expect(session[:subscriber]).to be_present
    end
  end

  describe '#find_subscriber_data' do
    it 'redirects to vehicles page when subscriber is found' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(response).to redirect_to(checkout_veiculos_path)
    end

    it 'creates subscriber session when subscriber is found' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(session[:subscriber]).to be_present
    end

    it 'redirects to vehicles page when subscriber is activated' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(response).to redirect_to(checkout_veiculos_path)
    end

    it 'creates subscriber session when subscriber is activated' do
      subscriber = FactoryBot.create(:subscriber)
      subscriber.update_attributes!(status: 'ativado')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(session[:subscriber]).to be_present
    end

    it 'redirects to identification page when subscriber isn\'t found' do
      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: 'any_user', password: 'any_password' } }

      expect(response).to redirect_to(checkout_identificacao_path)
    end

    it 'shows error message when subscriber isn\'t found' do
      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: 'any_user', password: 'any_password' } }

      expect(flash[:alert]).to eq('Falha na busca do assinante!')
    end

    it 'shoud not create subscriber session when subscriber isn\'t found' do
      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: 'any_user', password: 'any_password' } }

      expect(session[:subscriber]).to be_nil
    end

    it 'redirects to identification page when subscriber isn\'t activated' do
      subscriber = FactoryBot.create(:subscriber, status: 'pendente')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(response).to redirect_to(checkout_identificacao_path)
    end

    it 'shows error message when subscriber isn\'t activated' do
      subscriber = FactoryBot.create(:subscriber, status: 'pendente')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(flash[:alert]).to eq('Falha na busca do assinante!')
    end

    it 'shoud not create subscriber session when subscriber isn\'t activated' do
      subscriber = FactoryBot.create(:subscriber, status: 'pendente')

      session[:plan] = { name: 'standard', price: 10.0 }

      post :find_subscriber_data, params: { subscriber: { user: subscriber.user, password: subscriber.password } }

      expect(session[:subscriber]).to be_nil
    end
  end

  describe '#subscriber_address' do
    it 'returns address in JSON format when pass valid postal code' do
      postal_code = '04354-100'
      address_result = { neighborhood: "Vila Cordeiro",
                         zipcode: "04583100",
                         city: "São Paulo",
                         address: "Avenida Jurubatuba",
                         state: "SP",
                         complement: ""}

      allow(Correios::CEP::AddressFinder)
        .to receive(:get)
        .with(postal_code) { address_result }

      get :subscriber_address, params: { postal_code: postal_code }, format: :json

      expect(response.body).to eq(address_result.to_json)
    end

    it 'returns hash empty when pass invalid postal code' do
      postal_code = 'abcd'

      allow(Correios::CEP::AddressFinder)
        .to receive(:get)
        .with(postal_code) {{}}

      get :subscriber_address, params: { postal_code: postal_code }, format: :json

      expect(response.body).to eq({}.to_json)
    end

    it 'returns hash empty when address is not found' do
      postal_code = '99999-999'

      allow(Correios::CEP::AddressFinder)
        .to receive(:get)
        .with(postal_code) {{}}

      get :subscriber_address, params: { postal_code: postal_code }, format: :json

      expect(response.body).to eq({}.to_json)
    end

    it 'returns hash empty when pass occurs some errors' do

      postal_code = '04583-110'

      allow(Correios::CEP::AddressFinder)
        .to receive(:get)
        .with(postal_code) { raise StandardError }

      get :subscriber_address, params: { postal_code: postal_code }, format: :json

      expect(response.body).to eq({}.to_json)
    end
  end

  describe '#process_payment' do
    context 'when does exist subscriber' do
      it 'saves subscriber vehicle when new subscriber is saved' do
        plan = FactoryBot.create(:plan)

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        session[:subscriber] = subscriber
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:subscriber?) { true }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true } 
        allow(Order).to receive(:create!) { true }

        license_plate_1 = 'AAA-0000'
        license_plate_2 = 'ZZZ-9999'

        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => license_plate_1 },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => license_plate_2 } ]

        post :process_payment, params: { payment: payment_params }

        result_1 = Subscriber.find_by_code(session[:subscriber][:code]).vehicles.detect { |vehicle| vehicle.license_plate == license_plate_1 }
        result_2 = Subscriber.find_by_code(session[:subscriber][:code]).vehicles.detect { |vehicle| vehicle.license_plate == license_plate_2 }

        expect(result_1).to be_present
        expect(result_2).to be_present
      end

      it 'redirects to finalization page when save a new subscriber' do
        plan = FactoryBot.create(:plan)

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        session[:subscriber] = subscriber
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:subscriber?) { true }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Storage).to receive(:create_folder) { true }
        allow(Order).to receive(:create!) { true }

        license_plate_1 = 'AAA-0000'
        license_plate_2 = 'ZZZ-9999'

        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => license_plate_1 },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => license_plate_2 } ]

        post :process_payment, params: { payment: payment_params }

        expect(response).to redirect_to(checkout_finalizacao_path)
      end

      it 'shows error message when pass invalid data' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        session[:subscriber] = subscriber
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                             'kind' => 'Fusca',
                             'license_plate' => 'ABC-1000' },
                           { 'brand' => 'Ford',
                             'kind' => 'Palio',
                             'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }

        post :process_payment, params: { payment: payment_params }

        expect(flash[:alert]).to eq('Erro ao gravar dados!')
      end

      it 'redirects to identification page when not save a new subscriber' do
        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        session[:subscriber] = subscriber

        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }

        post :process_payment, params: { payment: payment_params }

        expect(response).to redirect_to(checkout_identificacao_path)
      end

      it 'saves a new subscription when pass valid data WITH subscriber and subscription are created in payment gateway' do
        plan = FactoryBot.create(:plan)

        session[:vehicle_list] = [ { brand: 'Volks',
                                     kind: 'Fusca',
                                     license_plate: 'AAA-0000' } ]

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        session[:subscriber] = subscriber
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscription_code = 'subscription-12345'

        allow(Gateways::Payment::Subscriber).to receive(:subscriber?) { true }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: subscription_code } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Order).to receive(:create!) { true }

        post :process_payment, params: { payment: payment_params }

        result = Subscription.find_by_code(subscription_code)

        expect(result).to be_present
      end

      it 'creates a new order when pass valid data WITH subscriber and subscription are created in payment gateway' do
        plan = FactoryBot.create(:plan)

        session[:vehicle_list] = [ { brand: 'Volks',
                                     kind: 'Fusca',
                                     license_plate: 'AAA-0000' } ]

        subscriber = FactoryBot.create(:subscriber)
        subscriber.status = 'ativado'
        subscriber.save!

        seller = FactoryBot.create(:seller)

        session[:subscriber] = subscriber
        session['seller'] = seller
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscription_code = 'subscription-12345'

        allow(Gateways::Payment::Subscriber).to receive(:subscriber?) { true }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: subscription_code } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }

        post :process_payment, params: { payment: payment_params }

        result = Subscription.find_by_code(subscription_code).order

        expect(result).to be_present
      end
    end

    context 'when doesn\'t exist subscriber' do
      it 'saves subscriber vehicle when new subscriber is saved' do
        plan = FactoryBot.create(:plan)

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: session[:subscriber].as_json['code'] } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Order).to receive(:create!) { true }

        license_plate_1 = 'AAA-0000'
        license_plate_2 = 'ZZZ-9999'

        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => license_plate_1 },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => license_plate_2 } ]

        post :process_payment, params: { payment: payment_params }

        result_1 = Subscriber.find_by_code(session[:subscriber].as_json['code']).vehicles.detect { |vehicle| vehicle.license_plate == license_plate_1 }
        result_2 = Subscriber.find_by_code(session[:subscriber].as_json['code']).vehicles.detect { |vehicle| vehicle.license_plate == license_plate_2 }

        expect(result_1).to be_present
        expect(result_2).to be_present
      end

      it 'redirects to finalization page when save a new subscriber' do
        plan = FactoryBot.create(:plan)

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: session[:subscriber].as_json['code'] } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Storage).to receive(:create_folder) { true }
        allow(Order).to receive(:create!) { true }

        license_plate_1 = 'AAA-0000'
        license_plate_2 = 'ZZZ-9999'

        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => license_plate_1 },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => license_plate_2 } ]

        post :process_payment, params: { payment: payment_params }

        expect(response).to redirect_to(checkout_finalizacao_path)
      end

      it 'shows error message when pass invalid data' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }

        post :process_payment, params: { payment: payment_params }

        expect(flash[:alert]).to eq('Erro ao gravar dados!')
      end

      it 'redirects to identification page when not save a new subscriber' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }

        post :process_payment, params: { payment: payment_params }

        expect(response).to redirect_to(checkout_identificacao_path)
      end

      it 'saves a new subscriber when pass valid data WITH subscriber and subscription are created in payment gateway' do
        plan = FactoryBot.create(:plan)

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }
        session[:vehicle_list] = [ { brand: 'VW', model: 'Fusca', license_plate: 'ABC-1234' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscriber_code = 'subscriber-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: subscriber_code } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Order).to receive(:create!) { true }

        post :process_payment, params: { payment: payment_params }

        result = Subscriber.find_by_code(subscriber_code)

        expect(result).to be_present
      end

      it 'saves a new subscription when pass valid data WITH subscriber and subscription are created in payment gateway' do
        plan = FactoryBot.create(:plan)

        session[:vehicle_list] = [ { brand: 'Volks',
                                     kind: 'Fusca',
                                     license_plate: 'AAA-0000' } ]
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscription_code = 'subscription-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: 'subscriber-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: subscription_code } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }
        allow(Order).to receive(:create!) { true }

        post :process_payment, params: { payment: payment_params }

        result = Subscription.find_by_code(subscription_code)

        expect(result).to be_present
      end

      it 'creates a new order when pass valid data WITH subscriber and subscription are created in payment gateway' do
        plan = FactoryBot.create(:plan)
        seller = FactoryBot.create(:seller)

        session[:vehicle_list] = [ { brand: 'Volks',
                                     kind: 'Fusca',
                                     license_plate: 'AAA-0000' } ]
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:seller] = seller
        session[:plan] = { name: plan.name, price: plan.price, code: plan.code }

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscription_code = 'subscription-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: 'subscriber-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: subscription_code } }
        allow(Gateways::Payment::Subscription).to receive(:update_recurrence) { true }

        post :process_payment, params: { payment: payment_params }

        result = Subscription.find_by_code(subscription_code).order

        expect(result).to be_present
      end

      it 'no saves a new subscriber when pass valid data WITHOUT subscriber and subscription creation' do
        Subscriber.delete_all

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 500, subscription_code: '' } }

        post :process_payment, params: { payment: payment_params }

        expect(Subscriber.all).to be_empty
      end

      it 'no saves a new subscriber when pass valid data and ONLY with created subscriber in payment gateway' do
        Subscriber.delete_all

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                    { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: 'subscriber-12345' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 500, subscription_code: '' } }

        post :process_payment, params: { payment: payment_params }

        expect(Subscriber.all).to be_empty
      end

      it 'no saves a new subscriber when pass valid data and ONLY with created subscription in payment gateway' do
        Subscriber.delete_all

        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 500, subscriber_code: '' } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }

        post :process_payment, params: { payment: payment_params }

        expect(Subscriber.all).to be_empty
       end

      it 'no saves a new subscriber when occurs some errors' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscriber_code = 'subscriber-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: subscriber_code } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Subscriber).to receive(:new) { raise StandardError }

        post :process_payment, params: { payment: payment_params }

        result = Subscriber.find_by_code(subscriber_code)

        expect(result).to be_nil
      end

      it 'shows error message when occurs some errors' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscriber_code = 'subscriber-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: subscriber_code } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Subscriber).to receive(:new) { raise StandardError }

        post :process_payment, params: { payment: payment_params }

        expect(flash[:alert]).to eq('Erro ao gravar dados!')
      end

      it 'redirects to identification page when occurs errors' do
        session[:subscriber] = FactoryBot.attributes_for(:subscriber)
        session[:plan] = { name: 'standard', price: 10.0, code: 'standard-angels' }
        session[:vehicle_list] = [ { 'brand' => 'Volks',
                                     'kind' => 'Fusca',
                                     'license_plate' => 'ABC-1000' },
                                   { 'brand' => 'Ford',
                                     'kind' => 'Palio',
                                     'license_plate' => 'XYZ-9999' } ]

        payment_params = { payment_method: 'Cartão de Crédito' ,
                           credit_card_number: '5484788254314887',
                           expiration_month: '06',
                           expiration_year: 'DateTime.now.year + 5',
                           holder_name: 'JOAO F DA SILVA' }

        subscriber_code = 'subscriber-12345'

        allow(Gateways::Payment::Subscriber).to receive(:create) { { status_code: 201, subscriber_code: subscriber_code } }
        allow(Gateways::Payment::Subscription).to receive(:create) { { status_code: 201, subscription_code: 'subscription-12345' } }
        allow(Subscriber).to receive(:new) { raise StandardError }

        post :process_payment, params: { payment: payment_params }

        expect(response).to redirect_to(checkout_identificacao_path)
      end
    end
  end

  describe '#vehicle_model_list' do
    it 'returns vehicle kind list sorted in JSON format when pass valid params' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
      vehicle_model_1 = FactoryBot.create(:vehicle_model, kind: 'Gol', vehicle_brand: vehicle_brand)
      vehicle_model_2 = FactoryBot.create(:vehicle_model, kind: 'Fusca', vehicle_brand: vehicle_brand)

      get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

      expect(response.body).to eq([vehicle_model_2.kind, vehicle_model_1.kind].to_json)
      expect(response.status).to eq(200)
    end

    it 'returns empty list in JSON format when occurs some errors' do
      allow(VehicleBrand).to receive(:find_by_brand) { raise StandardError }

      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_brand = FactoryBot.create(:vehicle_brand, brand: 'Volks')
      vehicle_model_1 = FactoryBot.create(:vehicle_model, kind: 'Gol', vehicle_brand: vehicle_brand)
      vehicle_model_2 = FactoryBot.create(:vehicle_model, kind: 'Fusca', vehicle_brand: vehicle_brand)

      get :vehicle_model_list, params: { vehicle_brand: vehicle_brand.brand }

      expect(response.body).to eq([].to_json)
      expect(response.status).to eq(200)
    end
  end

  describe '#vehicles' do
    it 'assigns variable with vehicle data hash list' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_list_session

      get :vehicles

      expect(assigns[:vehicle_list]).to be_present
    end

    it 'assigns variable with empty list when does exist session of vehicle data' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      get :vehicles

      expect(assigns[:vehicle_list]).to be_empty
    end
  end

  describe '#add_vehicles' do
    it 'adds new items in session of vehicle data' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_list_session

      brand = 'Ford'
      kind = 'Palio'
      license_plate = 'ZZZ-0000'

      expected_result = { 'brand' => brand, 'kind' => kind, 'license_plate' => license_plate }

      get :add_vehicles,
          params: { vehicle: { brand: brand,
                               kind: kind,
                               license_plate: license_plate } },
          xhr: true,
          format: :js

      expect(session[:vehicle_list]).to include(expected_result)
    end

    it 'shows error message when pass duplicated license plate' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_list_session

      license_plate = 'ZZZ-0000'

      session[:vehicle_list] = Array.new
      session[:vehicle_list] << { 'brand' => 'Ford',
                                  'kind' => 'Palio',
                                  'license_plate' => license_plate }

      new_vehicle = { 'brand' => 'Volks', 'kind' => 'Fusca', 'license_plate' => license_plate }

      get :add_vehicles,
          params: { vehicle: new_vehicle },
          xhr: true,
          format: :js

      expect(flash[:alert]).to eq('A placa do veículo já consta na lista!')
    end

    it 'no adds new item when pass duplicated license plate' do
      session[:subscriber] = FactoryBot.attributes_for(:subscriber)
      session[:plan] = { name: 'standard', code:  10.0 }

      vehicle_list_session

      license_plate = 'ZZZ-0000'

      session[:vehicle_list] = Array.new
      session[:vehicle_list] << { 'brand' => 'Ford',
                                  'kind' => 'Palio',
                                  'license_plate' => license_plate }

      new_vehicle = { 'brand' => 'Volks', 'kind' => 'Fusca', 'license_plate' => license_plate }

      get :add_vehicles,
          params: { vehicle: new_vehicle },
          xhr: true,
          format: :js

      expect(session[:vehicle_list]).not_to include(new_vehicle)
    end
  end

  describe '#remove_vehicles' do
    it 'deletes item of session that contain vehicle data' do
      session[:vehicle_list] = { brand: 'Volks', kind: 'Fusca', license_plate: 'AAA-1234' }

      get :remove_vehicles, params: { vehicle: { license_plate: 'AAA - 1234' } }

      expect(session[:vhicle_list]).to be_nil
    end

    it 'no deletes item of session that not contain vehicle data' do
      session[:vehicle_list] = { brand: 'Volks', kind: 'Fusca', license_plate: 'AAA-1234' }

      get :remove_vehicles, params: { vehicle: { license_plate: 'XYZ-0000' } }

      expect(session[:vehicle_list]).to be_present
    end

    it 'redirects to vehicles page when item of session that contain vehicle data is deleted' do
      session[:vehicle_list] = { brand: 'Volks', kind: 'Fusca', license_plate: 'AAA-1234' }

      get :remove_vehicles, params: { vehicle: { license_plate: 'AAA - 1234' } }

      expect(response).to redirect_to(checkout_veiculos_path)
    end
  end

  def vehicle_list_session
    session[:vehicle_list] = Array.new
    session[:vehicle_list] << { 'brand' => 'Volks', 'kind' => 'Fusca', 'license_plate' => 'ABC-1234' }
  end
end
