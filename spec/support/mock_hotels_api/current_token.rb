# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, 'https://hotels-api.h2oecoturismo.com.br/api/v1/current_token')
      .with(body:
        {
          email: 'h2o-ror@email.com',
          password: 'noronharecifefoz2050'
        }.to_json
      ).to_return(
        status: 200,
        body: {
          current_token: '1234abcd',
          expires_at: '2025-05-14T05:04:00.018Z'
        }.to_json,
        headers: {}
      )
  end
end
