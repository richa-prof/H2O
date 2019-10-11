# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, 'https://hotels-api.h2oecoturismo.com.br/api/v1/hotels?auth_token=1234abcd')
      .to_return(
        status: 200,
        body: [
          {
            "id" => 6,
            "name" => "Cache Test - Hotel Cert 2020 - RJ"
          },
          {
            "id" => 5,
            "name" => "Omnibees Test 1053"
          },
          {
            "id" => 2,
            "name" => "São Paulo 1054"
          }
         ].to_json,
        headers: {}
      )
  end
end
