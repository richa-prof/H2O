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
          "primary_language" => "pt-BR"
        }.to_json
      ).to_return(
        status: 200,
        body: {
          "reservation_info" => {
            "reservation_code" => "RES036046-1053",
            "grand_total" => 409.5,
            "room_breakdown" => [{
              "total_price" => 409.5,
              "room_info" => "Suíte Executiva (Ocupação máxima: 3)",
              "terms_info" => "Horário de Check-in: 14:00 horas",
              "cancellation_name" => "cancelamento 24",
              "cancellation_description" => "Cancelamento permitido ate 24 horas antes da data de chegada.",
              "meal" => "Café da manhã",
              "optional_extras" => [],
              "included_extras" => []
            }]
          }
        }.to_json,
        headers: {}
      )
  end
end
