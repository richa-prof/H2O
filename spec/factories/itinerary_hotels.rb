# frozen_string_literal: true

FactoryBot.define do
  factory :itinerary_hotel do
    quantidade                          { 1 }
    preco_unidade                       { 100 }
    total                               { 400 }
    produtos_hospedagem_configuracao_id { 9 }
    categoria                           { 'Super Luxo' }
    check_in                            { Date.current + 1.day }
    check_out                           { Date.current + 5.days }
    regime                              { 'Café da Manhã' }
    check_in_hora                       { '14:00' }
    check_out_hora                      { '11:00' }
    association :itinerary
    association :hotel
  end
end
