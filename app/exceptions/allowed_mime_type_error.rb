class AllowedMimeTypeError < StandardError
  def initialize(message = I18n.t('messages.errors.invalid_mime_type'))
    super
  end
end
