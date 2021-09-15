source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails', '~> 5.2.3'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.11'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'rubocop', '~> 0.71.0', require: false
gem 'rubycritic', require: false
gem 'rubocop-rails'
gem 'i18n'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'sassc-rails', '>= 2.1.0'
gem 'jquery-rails'
gem 'jquery-mask-plugin'
gem 'correios-cep'
gem 'password_strength'
gem 'rest-client'
gem 'chart-js-rails'
gem 'redis'
gem 'serviceworker-rails'
gem 'rqrcode'
gem 'activestorage-validator'
gem 'recaptcha'

# Sidekiq
gem 'sidekiq'
gem 'sidekiq-cron'
gem 'extensobr'

# Heartcheck
gem 'heartcheck'
gem 'heartcheck-webservice'
gem 'heartcheck-activerecord'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'
gem 'tzinfo-data'
gem 'will_paginate', '~> 3.1.0'

# AWS
gem 'aws-sdk', '~> 3'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'rspec-rails', '~> 3.8'
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'pry-rails'
  gem 'dotenv-rails'
  gem 'should_not'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rails-erd'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
  gem 'database_cleaner-active_record'
end
