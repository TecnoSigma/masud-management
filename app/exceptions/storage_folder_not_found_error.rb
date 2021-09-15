class StorageFolderNotFoundError < StandardError
  def initialize(message = I18n.t('messages.errors.folder_already_exists'))
    super
  end
end
