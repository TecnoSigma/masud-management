class MunitionObserver < ActiveRecord::Observer
  def after_save(munition)
    MunitionStock.create(
      caliber: munition.kind,
      quantity: munition.quantity,
      last_update: DateTime.now
    )

    Rails.logger.info(I18n.t('messages.infos.munition_stock_update',
                             caliber: munition.kind,
                             quantity: munition.quantity))
  end
end
