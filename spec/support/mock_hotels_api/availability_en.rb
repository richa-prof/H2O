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
          "start_date" => Date.current.strftime('%Y-%m-%d'),
          "end_date" => (Date.current + 3.days).strftime('%Y-%m-%d'),
          "primary_language" => "en-US"
        }.to_json
      ).to_return(
        status: 200,
        body: {
          "availability" => {
            "room_rates" => {
              "16719-23566-0" => {
                "rate" => 175.55,
                "is_marked_up" => false,
                "taxes" => 23.88
              },
              "2985-3872-0" => {
                "rate" => 555.33,
                "is_marked_up" => true,
                "taxes" => 0
              }
            },
            "room_types" => {
              "2985" => {
                "name" => "Suíte Executiva",
                "description" => "Espaçosas e confortáveis suítes",
                "max_occupancy" => 3,
                "detailed_occupancy" => "3 | 2"
              },
              "16719" => {
                "name" => "Deluxe",
                "description" => "ocean view",
                "max_occupancy" => 3,
                "detailed_occupancy" => "2 | 1"
              }
            },
            "rate_plans" => {
              "3872" => {
                "name" => "Night",
                "first_info" => "Breakfast at restaurant.",
                "additional_info_name" => "General Conditions",
                "additional_info_description" => "Check-in at 2 pm",
                "guarantee_name" => "Guaranteed",
                "guarantee_description" => "Reservations only if guaranteed",
                "cancelation_name" => "24-hour cancelation",
                "cancelation_description" => "24 hours prior is ok",
                "meal" => "Breakfast",
                "offers" => {},
                "included_extras" => [],
                "comission" => 0
              },
              "23566" => {
                "name" => "BAR 1",
                "first_info" => nil,
                "additional_info_name" => "Independence Day",
                "additional_info_description" => "check in at 2 pm",
                "guarantee_name" => nil,
                "guarantee_description" => nil,
                "cancelation_name" => "Non-refundable Rate",
                "cancelation_description" => "This rate is a non-refundable rate",
                "meal" => nil,
                "offers" => {
                  "226#0" => {
                    "description" => "Final de semana 1",
                    "percentage" => 50
                  }
                },
                "included_extras" => [],
                "comission" => nil
              }
            },
            "optional_extras" => {
              "3068" => {
                "price" => 30,
                "name" => "Pequeno Almoço",
                "description" => "Buffet pequeno almoço"
              },
              "3069" => {
                "price" => 50,
                "name" => "Meia Pensao",
                "description" => "Pequeno almoço e almoço"
              },
              "3070" => {
                "price" => 90,
                "name" => "pensao completa",
                "description" => "Pequeno almoço, almoço e jantar"
              },
              "3079" => {
                "price" => 100,
                "name" => "Tudo incluido",
                "description" => "Todas as refeiçoes estao incluidas."
              },
              "3080" => {
                "price" => 25,
                "name" => "Massagem",
                "description" => "Massagem de relaxamento."
              },
              "3081" => {
                "price" => 20,
                "name" => "Champanhe",
                "description" => nil
              },
              "3083" => {
                "price" => 30,
                "name" => "Bouquet flores",
                "description" => "Bouquet composto por diferentes tipos de flores."
              },
              "13204" => {
                "price" => 80,
                "name" => "All Inclusive",
                "description" => nil
              }
            },
            "request_echo_token" => "api_h2o_omnibees_734bdfa2",
            "start_date" => "2019-11-09T00:00:00",
            "end_date" => "2019-11-11T00:00:00"
          }
        }.to_json,
        headers: {}
      )
  end
end
