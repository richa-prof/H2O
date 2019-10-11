# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, 'https://hotels-api.h2oecoturismo.com.br/api/v1/availability?auth_token=1234abcd')
      .with(body:
        {
          "guest_count" => [{
            "total" => 2,
            "adults" => 2,
            "children" => 0,
            "children_ages" => []
          }],
          "hotel_id" => 5,
          "start_date" => "2019-11-01",
          "end_date" => "2019-11-01",
          "primary_language" => "pt-BR"
        }.to_json
      ).to_return(
        status: 200,
        body: {}.to_json,
        headers: {}
      )
  end
end
