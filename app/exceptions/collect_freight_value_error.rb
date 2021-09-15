class CollectFreightValueError < StandardError
  def initialize(message = I18n.t('messages.errors.calculate_freight_failed'))
    super
  end
end
