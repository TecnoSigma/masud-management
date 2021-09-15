class CheckoutController < ApplicationController
  before_action :check_plan_info, only: [:identification,
                                         :new_subscriber,
                                         :subscriber,
                                         :find_subscriber_data,
                                         :vehicles,
                                         :vehicle_model_list,
                                         :subscriber_info,
                                         :resume,
                                         :payment,
                                         :finalization]
  before_action :check_subscriber_info, only: [:resume,
                                               :vehicles,
                                               :vehicle_model_list,
                                               :payment,
                                               :finalization]
  before_action :calculate_freight, only: [:payment, :process_payment]
  
  def identification; end
  def new_subscriber; end
  def subscriber; end
  def payment; end

  def find_subscriber_data
    return unless verify_recaptcha
    subscriber = Subscriber
                   .where(user: subscriber_params[:user],
                          password: subscriber_params[:password])
                   .first

    raise FoundSubscriberError unless subscriber
    raise ActivatedSubscriberError unless subscriber.status == Status::STATUSES[:activated]

    session[:subscriber] = subscriber

    redirect_to checkout_veiculos_path
  rescue StandardError, ActivatedSubscriberError, FoundSubscriberError => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    redirect_to checkout_identificacao_path, alert: message_error(e.class)
  end

  def vehicles
    @vehicle_list = session[:vehicle_list].sort_by { |vehicle| vehicle['license_plate'] }
  rescue
    @vehicle_list = []
  end

  def resume
    session[:subscriber]['ip'] = Services::IpClient.ip
  end

  def finalization
    send_hiring_email!
  end

  def add_vehicles
    session[:vehicle_list] = Array.new if session[:vehicle_list].nil?

    vehicle_data = { "brand" => params[:vehicle][:brand],
                     "kind" => params[:vehicle][:kind],
                     "license_plate" => params[:vehicle][:license_plate] }

    duplicated_vehicle? ?
      flash[:alert] = I18n.t('messages.errors.duplicated_license_plate') :
      session[:vehicle_list] << vehicle_data

    respond_to { |format| format.js { render inline: 'location.reload();' } }
  end

  def remove_vehicles
    session[:vehicle_list].delete_if do |vehicle|
      vehicle['license_plate'] == params['vehicle']['license_plate']
    end

    redirect_to checkout_veiculos_path
  end

  def vehicle_model_list
    result = VehicleBrand
               .find_by_brand(params[:vehicle_brand])
               .vehicle_models
               .pluck(:kind)
               .sort

    render json: result, status: :ok
  rescue StandardError
    render json: [], status: :ok
  end

  def process_payment
    return unless verify_recaptcha

    subscriber_response = if session[:subscriber]['code']
                            { subscriber_code: session[:subscriber]['code'],
                              status_code:  Rack::Utils::HTTP_STATUS_CODES.key('OK') }
                          else
                            Gateways::Payment::Subscriber.create(session[:subscriber], payment_params)
                          end

    subscription_response = Gateways::Payment::Subscription
                              .create(plan_code: session[:plan]['code'],
                                      amount_payable: price_with_freight(amount_payable, @freight),
                                      subscriber_code: subscriber_response[:subscriber_code],
                                      payment_method: payment_params['payment_method'])

    update_subscription_response = Gateways::Payment::Subscription
                                     .update_recurrence(subscription_code: subscription_response[:subscription_code],
                                                        amount_payable: amount_payable)

    if save_subscriber!(subscriber_response, subscription_response) &&
         save_vehicles!(subscriber_response[:subscriber_code]) &&
         update_subscription_response

      create_order(subscription_code: subscription_response[:subscription_code], price: amount_payable)

      if Plan::PLAN_CODES_WITH_STORAGE.include?(session[:plan]['code'])
        Storage.create_folder(subscription_response[:subscription_code])
      end

      redirect_to checkout_finalizacao_path
    else
      redirect_to checkout_identificacao_path,
                  alert: I18n.t('messages.errors.save_data_failed')  
    end
  rescue => e
    Rails.logger.error("Message: #{e.message} - Backtrace: #{e.backtrace}")

    redirect_to checkout_identificacao_path,
                alert: I18n.t('messages.errors.save_data_failed')
  end

  def user_availability
    result = Subscriber.active.find_by_user(params['user']).present? ?
               { 'available' => false } :
               { 'available' => true }

    render json: result, status: :ok
  rescue StandardError
    render json: { 'available' => false }, status: :ok
  end

  def check_seller
    seller = Seller.activated.find_by_document(params['seller_cpf'])

    session[:seller] = seller

    render json: (seller.present?).to_json, status: :ok
  rescue StandardError
    render json: false.to_json, status: :internal_server_error
  end

  def subscriber_info
    session[:subscriber] = new_subscriber_params

    redirect_to checkout_veiculos_path
  end

  def subscriber_address
    render json: address.as_json,
           status: :ok
  rescue StandardError
    render json: {},
           status: :not_found
  end

  private
    def create_order(subscription_code:, price:)
      subscription = Subscription.find_by_code(subscription_code)
      seller = Seller.find_by_document(session['seller'].try(:document))

      Order.create!(price: price,
                    status: Status::STATUSES[:pendent],
                    subscription: subscription,
                    seller: seller)
    end

    def calculate_freight
      postal_code = session[:subscriber]['postal_code'] || session[:subscriber][:postal_code]
      plan_price = session[:plan]['price'] || session[:plan][:price]

      @freight = Freight
                   .calculate(postal_code: postal_code,
                              price: plan_price.to_f,
                              quantity: session[:vehicle_list].count)
    end

    def price_with_freight(price, freight)
      price.to_f + freight.to_f
    end

    def message_error(class_error)
      case class_error
        when FoundSubscriberError
          I18n.t('messages.errors.search_subscriber_failed')
        when ActivatedSubscriberError
          I18n.t('messages.errors.subscriber_not_activated')
        else
          I18n.t('messages.errors.search_subscriber_failed')
      end
    end

    def amount_payable
      session[:plan]['price'].to_f * session[:vehicle_list].count.to_f
    end

    def duplicated_vehicle?
      session[:vehicle_list]
        .select { |vehicle| vehicle['license_plate'] == params[:vehicle][:license_plate] }
        .present?
    end

    def send_hiring_email!
      Notifications::Hiring.finalization(session[:subscriber]).deliver_now!
    end

    def save_vehicles!(subscriber_code)
      subscriber = Subscriber.find_by_code(subscriber_code)

      return false unless subscriber

      session[:vehicle_list].each do |vehicle|
        Vehicle.create(brand: vehicle['brand'],
                       kind: vehicle['kind'],
                       license_plate: vehicle['license_plate'],
                       subscriber: subscriber)
      end

      true
    end

    def save_subscriber!(subscriber_args, subscription)
      session[:plan].symbolize_keys!

      plan = Plan.find_by_code(session[:plan][:code])

      subscriber = Subscriber.find_by_code(subscriber_args[:subscriber_code]) ||
                     Subscriber.new(session[:subscriber])
      subscriber.code = subscriber_args[:subscriber_code]
      subscriber.plan = plan

      accepted_statuses = [ Rack::Utils::HTTP_STATUS_CODES.key('OK'),
                            Rack::Utils::HTTP_STATUS_CODES.key('Created') ]

      if accepted_statuses.include?(subscriber_args[:status_code]) &&
        accepted_statuses.include?(subscription[:status_code]) &&
        subscriber.valid?

        subscriber.save!

        Subscription.create(code: subscription[:subscription_code],
                            vehicles_amount: session[:vehicle_list].count,
                            status: Status::STATUSES[:activated],
                            subscriber: subscriber)
      end
    end

    def address
      address = Correios::CEP::AddressFinder.get(params['postal_code'])

      return address if address.empty?

      address[:state] = States.state_name(address[:state])

      address
    end

    def check_plan_info
      redirect_to root_path unless session[:plan].present?
    end

    def check_subscriber_info
      redirect_to root_path unless session[:subscriber].present?
    end

    def subscriber_params
      params
        .require(:subscriber)
        .permit(:user,
                :password)
    end

    def new_subscriber_params
      params
        .require(:new_subscriber)
        .permit(:name,
                :responsible_cpf,
                :responsible_name,
                :document,
                :kind,
                :address,
                :number,
                :complement,
                :district,
                :city,
                :state,
                :postal_code,
                :ip,
                :email,
                :telephone,
                :cellphone,
                :user,
                :password)
        .merge(status: Status::STATUSES[:pendent])
    end

  def payment_params
    params
      .require(:payment)
      .permit(:payment_method,
              :credit_card_number,
              :expiration_month,
              :expiration_year,
              :holder_name)
  end
end
