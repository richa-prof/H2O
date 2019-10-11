# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'cielo-api30'
gem 'coffee-rails', '~> 4.2'
gem 'devise', '~> 4.5'
gem 'friendly_id'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'mysql2', '~> 0.5.2'
gem 'puma', '~> 3.7'
gem 'rails', '~> 5.2'
gem 'rest-client'
gem 'route_translator'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'will_paginate'
gem 'rails_admin'
gem 'paper_trail'
gem 'bootsnap', '~> 1.3'
gem 'mini_magick'

group :production do
  gem 'rails_12factor'
  gem 'newrelic_rpm'
  gem 'aws-sdk-s3', require: false
  gem 'heroku-deflater'
  gem 'tunemygc'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'webmock'
  gem 'orderly'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'neatjson'
end

group :development do
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
  gem 'bullet'
end
