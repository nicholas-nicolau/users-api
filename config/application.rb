require_relative "boot"

require "rails/all"
Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application

    config.load_defaults 7.0

    config.api_only = true

    config.i18n.default_locale = 'pt-BR'

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_bot
      g.factory_bot dir: 'spec/factories'
    end
    
    config.middleware.use Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
          methods: [:get, :post, :options, :delete, :put]
      end
    end
  end
end
