# frozen_string_literal: true

FactoryBot.define do
  factory :itinerary do
    adm_usuario_id   { 133 }
    status           { 'Pendente' }
    categoria        { 'Site H2O' }
    hotel            { 'Hotel Transilvânia' }
    inicio_da_viagem { Date.current - 5.days }
    fim_da_viagem    { Date.current + 5.days }
    subtotal         { 90 }
    desconto         { 0 }
    total            { 90 }
    data             { DateTime.current }
    canal_id         { 4 }
    indicador_id     { 15 }
    funil_venda_id   { 8 }
    association :user
  end
end
