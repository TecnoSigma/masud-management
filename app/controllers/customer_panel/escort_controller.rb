#frozen_string_literal: true

class CustomerPanel::EscortController < PanelsController
  def list
    @orders = customer
      .escorts
      .paginate(per_page: Order::PER_PAGE_IN_CUSTOMER_DASHBOARD,
                page: params[:page])
  end

  def create
    escort = EscortScheduling.new(escort_params)

    escort.validate!
    escort.save!

    send_scheduling_notifications(customer, escort)

    redirect_to customer_panel_dashboard_escolta_lista_path,
                notice: t('messages.successes.scheduling_creation_successfully')
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to customer_panel_dashboard_escolta_lista_path,
                alert: t('messages.errors.scheduling_creation_failed')
  end

  def cancel
    raise DeleteEscortSchedulingError unless escort.deletable?

    escort
      .update(
        deleted_at: DateTime.now,
        status: Status.find_by_name('cancelado pelo cliente')
    )

    redirect_to customer_panel_dashboard_escolta_lista_path,
                notice: t('messages.successes.scheduling_cancelation_successfully')
  rescue DeleteEscortSchedulingError, StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to customer_panel_dashboard_escolta_lista_path,
                alert: t('messages.errors.scheduling_cancelation_failed')
  end

  def show
    @escort = escort
  end

  private

  def escort
    customer
      .escorts
      .detect { |escort| escort.order_number == params['order_number'] }
  end

  def send_scheduling_notifications(customer, escort)
    emails_list.each do |email|
      begin
        Notifications::Customers::Orders::Escort
          .scheduling(
            customer: customer,
            escort: escort,
            email: email
          )
          .deliver_now!
      rescue StandardError => error
        Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

        next
      end
    end
  end

  def emails_list
    [
      customer.email,
      customer.secondary_email,
      customer.tertiary_email
    ].compact
  end

  def escort_params
    params.require(:escort).permit(
      :job_day,
      :source_address,
      :source_number,
      :source_complement,
      :source_district,
      :source_city,
      :source_state,
      :destiny_address,
      :destiny_number,
      :destiny_complement,
      :destiny_district,
      :destiny_city,
      :destiny_state,
      :observation
    ).merge('customer' => customer,
            'status' => Status.find_by_name('agendado'))
  end

  def customer
    @customer ||= ServiceToken.find_by_token(session[:customer_token]).customer
  end
end
