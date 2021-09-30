#frozen_string_literal: true

class CustomerPanel::EscortController < PanelsController
  def list
    @orders = customer
      .escorts
      .paginate(per_page: Order::PER_PAGE_IN_CUSTOMER_DASHBOARD,
                page: params[:page])
  end

  def create
    escort = Escort.new(escort_params)

    escort.validate!
    escort.save!

    redirect_to customer_panel_dashboard_escolta_lista_path,
                notice: t('messages.successes.scheduling_creation_successfuly')
  rescue StandardError => error
    Rails.logger.error("Message: #{error.message} - Backtrace: #{error.backtrace}")

    redirect_to customer_panel_dashboard_escolta_lista_path,
                alert: t('messages.errors.scheduling_creation_failed')
  end

  private

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
