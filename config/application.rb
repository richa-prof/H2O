require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module SiteH2oRor
  class Application < Rails::Application
    config.load_defaults 5.1
    config.generators.system_tests = nil
    config.i18n.available_locales = ['en', 'pt-BR']
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = 'pt-BR'
    config.time_zone = 'America/Campo_Grande'
    config.active_record.time_zone_aware_attributes = false
    config.eager_load_paths << Rails.root.join('lib')
  end
end
