# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:post, 'https://hotels-api.h2oecoturismo.com.br/api/v1/availability?auth_token=1234abcd')
      .with(body:
        {
          "guest_count" => [{
            "total" => 3,
            "adults" => 2,
            "children" => 1,
            "children_ages" => [9]
          }],
          "hotel_id" => 5,
          "start_date" => "2019-11-09",
          "end_date" => "2019-11-11",
          "primary_language" => "pt-BR"
        }.to_json
      ).to_return(
        status: 200,
        body: {
          "availability" => {
            "room_rates" => {
              "16719-23566-0" => {
                "rate" => 226,
                "is_marked_up" => false,
                "taxes" => 0
              },
              "2985-3872-0" => {
                "rate" => 409.5,
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
                "name" => "Luxo ",
                "description" => "Quarto espaçoso, com vista mar.",
                "max_occupancy" => 3,
                "detailed_occupancy" => "2 | 1"
              }
            },
            "rate_plans" => {
              "3872" => {
                "name" => "Diaria",
                "first_info" => "Inclui café da manhã, servido no restaurante do hotel.",
                "additional_info_name" => "Condições Gerais",
                "additional_info_description" => "Horário de Check-in: 14:00 horas",
                "guarantee_name" => "Garantia de no show",
                "guarantee_description" => "Reservas SOMENTE com garantia de NO SHOW",
                "cancelation_name" => "cancelamento 24",
                "cancelation_description" => "Cancelamento permitido ate 24 horas antes da data de chegada.",
                "meal" => "Café da manhã",
                "offers" => {},
                "included_extras" => [],
                "comission" => 0
              },
              "23566" => {
                "name" => "BAR 1",
                "first_info" => nil,
                "additional_info_name" => "Feriado Independencia ",
                "additional_info_description" => "Horário de check-in a partir das 14:00 horas",
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
            "request_echo_token" => "api_h2o_omnibees_aa8d0e96",
            "start_date" => "2019-11-09T00:00:00",
            "end_date" => "2019-11-11T00:00:00"
          }
        }.to_json,
        headers: {}
      )
  end
end
