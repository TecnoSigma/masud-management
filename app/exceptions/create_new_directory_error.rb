class CreateNewDirectoryError < StandardError
  def initialize(message = I18n.t('messages.errors.create_folder_failed'))
    super
  end
end
