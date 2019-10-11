# frozen_string_literal: true

FactoryBot.define do
  factory :cupon do
    chave       { 'this-awesome-cupon' }
    tipo        { %w[Porcentagem BRL].sample }
    brl         { 5 }
    porcentagem { 10 }
    limite      { nil }
    vezes_usado { 7 }
    usuario_id  { nil }
    vencimento  { DateTime.current + 3.months }
  end
end
