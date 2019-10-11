# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, 'https://hotels-api.h2oecoturismo.com.br/api/v1/reservation?auth_token=1234abcd')
      .with(body:
        {
          "request_echo_token" => "api_h2o_omnibees_aa8d0e96",
          "room_distribution" => [{
            "client_name" => "Donna Roberta Paulsen",
            "client_doc" => "5678910",
            "foreign_info" => "CA 828",
            "guest_names" => [],
            "selected_room" => "2985-3872-0",
            "optional_extras" => []
          }],
          "primary_language" => "en-US"
        }.to_json
      ).to_return(
        status: 200,
        body: {
          "reservation_info" => {
            "reservation_code" => "RES036046-1053",
            "grand_total" => 409.5,
            "room_breakdown" => [{
              "total_price" => 409.5,
              "room_info" => "Executive Suite (Max Occupants: 3)",
              "terms_info" => "check in at 2 pm",
              "cancellation_name" => "24 hours",
              "cancellation_description" => "24 hours prior to check in",
              "meal" => "breakfast",
              "optional_extras" => [],
              "included_extras" => []
            }]
          }
        }.to_json,
        headers: {}
      )
  end
end
