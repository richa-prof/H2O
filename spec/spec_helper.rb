require 'simplecov'
SimpleCov.start 'rails'
require 'webmock/rspec'

hash_of_allowed_net_connections = [
  %r{cielo},
  %r{https://chromedriver.storage.googleapis.com}
]
WebMock.disable_net_connect!(allow_localhost: true, allow: hash_of_allowed_net_connections)

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random
  config.shared_context_metadata_behavior = :apply_to_host_groups
end
