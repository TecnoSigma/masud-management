module Messages
  class << self
    def errors
      { required_field: I18n.t('messages.errors.required_field'),
        invalid_rate: I18n.t('messages.errors.invalid_rate'),
        invalid_characater_quantity: I18n.t('messages.errors.invalid_characater_quantity'),
        invalid_format: I18n.t('messages.errors.invalid_format'),
        invalid_status: I18n.t('messages.errors.invalid_status'),
        invalid_plan_name: I18n.t('messages.errors.invalid_plan_name'),
        invalid_price: I18n.t('messages.errors.invalid_price'),
        invalid_user: I18n.t('messages.errors.invalid_user'),
        invalid_date: I18n.t('messages.errors.invalid_date'),
        invalid_data: I18n.t('messages.errors.invalid_data'),
        already_license_plate: I18n.t('messages.errors.already_license_plate'),
        already_user: I18n.t('messages.errors.already_user'),
        already_document: I18n.t('messages.errors.already_document'),
        already_core_register: I18n.t('messages.errors.already_core_register'),
        already_plan_name: I18n.t('messages.errors.already_plan_name'),
        already_plan_code: I18n.t('messages.errors.already_plan_code'),
        not_allowed_photo_quantity: I18n.t('messages.errors.not_allowed_photo_quantity') }
    end
  end
end
