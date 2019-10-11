FactoryBot.define do
  factory :tour_stock_date do
    subvariacao       { (Date.current + 2.weeks).strftime("%d/%m/%Y") }
    estoque           { 7 }
    numero_de_reserva { 'ABC XYZ' }
    status            { ['Ativo','Excluido'].sample }
    association :tour_stock_time
  end
end
