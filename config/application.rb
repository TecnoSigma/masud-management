require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MasudManagement
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.i18n.default_locale = 'pt-BR'

    config.autoload_paths += %W[
      #{config.root}/lib
      #{config.root}/app/presenters
      #{config.root}/app/exceptions
    ]

    # Observers
    config.active_record.observers = :munition_observer

    # Notifications
    unless Rails.env.test?
      config.action_mailer.delivery_method = :smtp

      config.action_mailer.smtp_settings = {
        address: ENV['EMAIL_ADDRESS'],
        port: 587,
        domain: ENV['EMAIL_DOMAIN'],
        authentication: 'plain',
        enable_starttls_auto: true,
        user_name: ENV['EMAIL_ACCOUNT'],
        password: ENV['EMAIL_PASSWORD']
      }
    end
  end
end
