# frozen_string_literal: true

FactoryBot.define do
  factory :itinerary_tour do
    passeio_data           { Date.current + 3.days }
    passeio_hora           { '13:00' }
    reserva                { 'ABCXYZ' }
    total                  { 90 }
    qtde_adt               { 3 }
    qtde_chd               { 1 }
    qtde_free              { 2 }
    qtde_adt_almoco        { 0 }
    qtde_chd_almoco        { 0 }
    qtde_free_almoco       { 0 }
    produto_subvariacao_id { nil }
    excluido               { nil }
    voucher_numero         { nil }
    voucher_tabela         { nil }
    btms_tabela            { nil }
    passeio_hora_saida     { nil }
    association :itinerary
    association :tour
  end
end
