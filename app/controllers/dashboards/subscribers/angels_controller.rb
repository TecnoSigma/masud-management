class Dashboards::Subscribers::AngelsController < ApplicationController
  before_action :validate_sessions
  before_action :find_subscriber

  def index; end

  def insert
    @angel = Angel.new
  end

  def edit
    @angel = @subscriber.angels.detect { |angel| angel.id == params['angel'].to_i }
 
    unless @angel.present?
      redirect_to dashboards_assinantes_angels_path,
                  alert: I18n.t('messages.errors.search_data_failed')
    end
  rescue
    redirect_to dashboards_assinantes_angels_path,
                alert: I18n.t('messages.errors.search_data_failed')
  end

  def remove
    angel = @subscriber.angels.detect { |angel| angel.id == params['angel'].to_i }

    if angel.present?
      angel.delete

      redirect_to dashboards_assinantes_angels_path,
                  notice: I18n.t('messages.successes.remove_data')
    else
      redirect_to dashboards_assinantes_angels_path,
                  alert: I18n.t('messages.errors.remove_data_failed')
    end
  rescue
    redirect_to dashboards_assinantes_angels_path,
                alert: I18n.t('messages.errors.remove_data_failed')
  end

  def update
    angel = @subscriber.angels.detect { |angel| angel.id == params['angel_id'].to_i }

    if angel.update_attributes!(angel_params)
      redirect_to dashboards_assinantes_angels_path,
                  notice: I18n.t('messages.successes.update_data')
    else
      redirect_to dashboards_assinantes_angels_path,
                  alert: I18n.t('messages.errors.save_data_failed')
    end
  rescue
    redirect_to dashboards_assinantes_angels_path,
                alert: I18n.t('messages.errors.save_data_failed')
  end

  def create
    angel = Angel.new(angel_params)

    if angel.valid?
      angel.save!

      redirect_to dashboards_assinantes_angels_path,
                  notice: I18n.t('messages.successes.save_data')
    else
      redirect_to dashboards_assinantes_angels_path,
                  alert: I18n.t('messages.errors.save_data_failed')
    end
  rescue
    redirect_to dashboards_assinantes_angels_path,
                alert: I18n.t('messages.errors.save_data_failed')
  end

  private

    def angel_params
      params
        .require(:angel)
        .permit(:name, :cpf, :status)
        .merge!({ subscriber: @subscriber })
    end
end
